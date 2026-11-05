<#
.SYNOPSIS
Sync justsec-agent-kit into the global OpenCode config (~/.config/opencode).

.DESCRIPTION
Structure this script assumes (current justsec-agent-kit layout):

  skills/                one directory per skill, each with a SKILL.md
                         -> linked individually as global skill junctions
  agents/*-agent.md      six top-level domain-agent personas
                         -> copied as global agent files (no subdirectories)
  instructions/          domain standards, NOT touched here (loaded via the
                         'instructions' array in opencode.json)

It never recurses into agents/ for agents, never copies skill content into the
agent directory, and never flattens files by name.

Windows note: creating file symlinks requires admin/Developer Mode (not assumed
here). Directory junctions (skills) do not require elevation and are used
instead. Agents are single .md files, so they are copied -- re-run this script
after editing one.

Junctions are removed with a link-only delete, so the target skill directory is
never touched.

.PARAMETER SharedPath
Path to the justsec-agent-kit checkout. Defaults to this script's parent directory.

.PARAMETER GlobalPath
Path to the global OpenCode config dir. Defaults to ~/.config/opencode.

.EXAMPLE
powershell -File .\scripts\sync-global-opencode.ps1
#>
[CmdletBinding()]
param(
    [string]$SharedPath = (Split-Path -Parent $PSScriptRoot),
    [string]$GlobalPath = "$env:USERPROFILE\.config\opencode"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SharedPath)) {
    throw "Shared checkout not found: $SharedPath"
}
$Shared = (Resolve-Path -LiteralPath $SharedPath).Path
$Global = $GlobalPath

if (-not (Test-Path -LiteralPath "$Shared\skills") -or -not (Test-Path -LiteralPath "$Shared\agents")) {
    throw "Not an justsec-agent-kit checkout (missing skills/ or agents/): $Shared"
}

$SkillDir = Join-Path $Global "skill"
$AgentDir = Join-Path $Global "agent"
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null

Write-Output "Shared source : $Shared"
Write-Output "Global target : $Global"
Write-Output ""

function Test-IsLink([System.IO.FileSystemInfo]$Item) {
    return [bool]($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function Get-LinkTarget([string]$Path) {
    # Returns the first target path of a junction/symlink, or $null.
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item -or -not (Test-IsLink $item)) { return $null }
    $target = $item.Target | Select-Object -First 1
    return $target
}

function Remove-LinkOnly([string]$Path) {
    # Deletes the link itself, never the target. Refuses real directories/files.
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item) { return }
    if (-not (Test-IsLink $item)) { return }
    if ($item.PSIsContainer) { [System.IO.Directory]::Delete($Path, $false) }
    else { [System.IO.File]::Delete($Path) }
}

Write-Output "== Syncing skills (junctions) =="
$skillDirs = Get-ChildItem -LiteralPath "$Shared\skills" -Recurse -File -Filter "SKILL.md" |
    ForEach-Object { $_.Directory }

$dupNames = $skillDirs | Group-Object -Property Name | Where-Object { $_.Count -gt 1 }
foreach ($dup in $dupNames) {
    Write-Warning "duplicate skill folder name '$($dup.Name)' in $($dup.Count) paths; only the first is linked"
}

$current = @{}
$linked = 0
foreach ($dir in ($skillDirs | Sort-Object FullName)) {
    $name = $dir.Name
    if ($current.ContainsKey($name)) { continue }

    $dest = Join-Path $SkillDir $name
    $existing = Get-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if (-not (Test-IsLink $existing)) {
            Write-Warning "skip (existing non-link path is in the way): $name"
            continue
        }
        $target = Get-LinkTarget $dest
        if ($target -and ($target -notlike "$Shared\skills*")) {
            Write-Warning "skip (existing link points outside this checkout): $name -> $target"
            continue
        }
        Remove-LinkOnly $dest
    }

    New-Item -ItemType Junction -Path $dest -Target $dir.FullName | Out-Null
    $current[$name] = $true
    Write-Output "  linked: $name"
    $linked++
}

# Prune junctions created by this script whose source skill no longer exists.
$pruned = 0
Get-ChildItem -LiteralPath $SkillDir -Force -ErrorAction SilentlyContinue | ForEach-Object {
    if ($current.ContainsKey($_.Name)) { return }
    $target = Get-LinkTarget $_.FullName
    if ($target -and ($target -like "$Shared\skills*")) {
        Remove-LinkOnly $_.FullName
        Write-Output "  pruned stale skill: $($_.Name)"
        $pruned++
    }
}

Write-Output ""
Write-Output "== Syncing agents (copies -- re-run after edits) =="
# Top-level *-agent.md only (non-recursive). agents/ holds no skill copies.
$agents = Get-ChildItem -LiteralPath "$Shared\agents" -File -Filter "*-agent.md" | Sort-Object Name
foreach ($agent in $agents) {
    $dest = Join-Path $AgentDir $agent.Name
    Copy-Item -LiteralPath $agent.FullName -Destination $dest -Force
    Write-Output "  copied: $($agent.Name)"
}

Write-Output ""
Write-Output "Done. Skills linked: $linked (stale pruned: $pruned)  Agents copied: $($agents.Count)"
Write-Warning "Older copied agent files are not automatically deleted. Review and remove superseded personas from $AgentDir manually (cloud-agent, infra-agent, repo-analyze-agent, understand-agent)."
Write-Output "Instructions are referenced via the 'instructions' array in opencode.json, not copied."
Write-Output "Re-run after adding/removing a skill, or after editing an agent."
