---
name: linux-platform-change
description: Planning and diagnosis discipline for Linux and platform changes (services, systemd, udev, firewall, packages, kernel, hardware, installs). Every plan names exact target, change, evidence, blast radius and rollback; privileged commands are handed to the human as full copy-paste ssh -t host 'sudo ...' lines; never gain root through the docker group; tests never touch a live config or running service. Diagnose read-only first; change state only through a reviewed plan.
---

# linux-platform-change

## Purpose
Keep inspection and mutation **separate**. Diagnose with read-only commands first; change state only through a plan the human has seen. The failure this prevents is a well-intentioned change to a live host that has no rollback, no blast-radius statement, and no evidence it was needed.

## When To Use
- Service, systemd, udev, firewall, package, kernel, hardware or install work on real hosts (home lab, Proxmox node, pfSense box, SIEM stack, server VM).
- Any diagnosis or change that touches system state rather than application code.
- **Not for** application code that touches no system state.

## Inputs Expected
- The symptom or goal, and the exact target (machine label, unit, file or device).
- Read-only access for diagnosis; the human's willingness to paste privileged commands.
- The blast radius (what else breaks if it is wrong), including reboot persistence.

## Step-By-Step Process
1. **Diagnose read-only.** Run the least invasive diagnostic commands; record what was observed and by which command.
2. **Write a plan that names five things:** the exact **target**, the **change**, the **evidence** that justifies it, the **blast radius** (what else breaks if it is wrong, including reboot persistence), and the **rollback** (exact commands, with a backup taken first). A plan missing one of the five is not ready.
3. **Hand privileged commands over; do not run them.** Give the human full copy-paste lines of the form `ssh -t host 'sudo ...'`, using the placeholder `host` — never a real name or address. No bare subcommands, no "run X as root". Prefer a tool that elevates itself with a clear prompt over telling the user to prefix `sudo`.
4. **Check what the fix depends on:** service dependencies, permissions, firewall reachability, and whether it survives a reboot (say explicitly if you did not verify reboot persistence).
5. **Label every command** read-only or a change. Prefer the least invasive diagnostic, then a reversible fix.
6. **Before any change that alters networking, reboots, or is destructive:** stop and get the human's explicit approval of **the exact plan**. Silence, or an earlier general go-ahead, is not approval.

## Rules That Prevent Known Incidents
- **Never gain root through the docker group.** Docker-group membership is root-equivalent: do not mount the host filesystem into a container, and do not run a privileged container, to edit system files. Ask for a proper `sudo` line instead.
- **Never touch a live config or a running service from a test.** No test, fixture capture, or helper may write the real config of the thing under test or restart a running service — including through a `HOME` override or an environment redirect. State-changing commands of the project under test run only in a container or VM; tests use a temporary directory and a fake of the service.
- **GUI/build work stays light.** Builds and GUI-adjacent tooling run at `nice -n 19` and `-j2`. Do not launch a GUI app, a virtual-display session, or a full-parallel build on the human's own desktop — one such run has crashed and blanked a live session.
- **Identify machines by hardware model + last three serial characters only.** Never a hostname, full serial, or asset tag.

## Validation Checklist
- [ ] Every command in the plan is a full paste-able line, with `host` as the placeholder (`grep -nE '^(ssh|sudo)' <plan>` shows only `ssh -t host 'sudo ...'` forms)
- [ ] No privileged-container host-mount (`grep -nE 'docker run .*(--privileged|-v /:)' <plan>` returns nothing)
- [ ] No test in the diff reads or writes a real config path or a live unit
- [ ] The rollback was written **before** the change, not after
- [ ] The plan names target, change, evidence, blast radius and rollback
- [ ] Reboot persistence is verified or explicitly stated as unverified
- [ ] Networking/reboot/destructive steps have the human's explicit approval of the exact plan
- [ ] Machine identifiers are model + last three serial chars (no hostname/serial/asset tag)

## Output Format
The agent's standard report header, then:
- Diagnosis: what was observed, and by which read-only command.
- Diagnostic commands for the human, as full lines.
- Change plan: target / change / evidence / blast radius / rollback.
- Post-change checks, including reboot persistence.

## Safety Notes
- Read-only until the human approves the exact plan; never run privileged commands yourself.
- Do not invent machine names, addresses, or serials — use `host` and the model + last-three rule.
- Approval is never inferred (see `instructions/ai-agents/agent-safety.instructions.md`).

Related instructions: `instructions/devsecops/devsecops-general.instructions.md`, `instructions/docker/docker-best-practices.instructions.md`
Related skills: `skills/infrastructure/servers/linux-administration/SKILL.md`, `skills/infrastructure/servers/systemd-services/SKILL.md`, `skills/security/hardening/linux-hardening/SKILL.md`, `skills/quality/verification-before-completion/SKILL.md`

Attribution: adapted from `ChiefGyk3D/department-of-internal-arguments` pack `linux-platform` (MIT, © 2026 ChiefGyk3D).
