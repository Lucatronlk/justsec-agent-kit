---
name: electron-typescript
description: Build and review TypeScript Electron desktop features across main, preload and renderer processes. Use for windows, navigation, lifecycle, packaging-facing changes and desktop integrations; pair with electron-ipc-security for any new privileged bridge.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# electron-typescript

## Purpose and scope
Engineer Electron desktop functionality without confusing browser, preload and main-process privileges. For privileged renderer-to-main calls, use `electron-ipc-security` alongside this skill; `typescript-development` covers ordinary implementation. This is not a universal instruction to change a VS Code fork's established process architecture.

## Inputs
Target feature, Electron version and app architecture, process ownership, `BrowserWindow`/`webContents` setup, preload and protocol registration, supported platforms, scripts and tests. Verify repository-specific abstractions before proposing Electron APIs.

## Workflow
1. Map the feature to main, preload or renderer (and utility/extension-host processes if present); state why each capability belongs there. Trace startup, disposal and error paths.
2. Use typed, narrowly scoped interfaces at crossings; inspect existing bridges rather than adding parallel global APIs. When adding IPC or webview messages, invoke `electron-ipc-security` and `typescript-untrusted-input`.
3. Preserve context isolation and renderer sandboxing; do not enable Node integration, disable webSecurity, or broaden preload exposure to make a feature easier. Apply a restrictive CSP and navigation/window-open/permission policy when the feature changes content loading.
4. Keep network, file, shell, and custom-protocol operations in trusted code behind explicit authorization and resource limits. Parse URLs by protocol and origin, not string prefix; never hand untrusted URLs to `shell.openExternal`.
5. Test lifecycle (create/close/reopen), cleanup of listeners, denied navigation and renderer failure/restart. Run existing project typecheck, focused tests and applicable platform build only after inspecting scripts for side effects.

## Validation checklist
- [ ] Process ownership and main/preload/renderer trust boundaries documented.
- [ ] Privileged crossings use reviewed, minimal IPC contracts; renderer has no raw Node/Electron access.
- [ ] Navigation, content policy and permissions remain restrictive; exceptions documented and tested.
- [ ] Disposal/restart and error-path tests exist; supported-platform validation is run or explicitly not-run.
- [ ] No installation, packaging, signing, publishing or deployment without explicit authorization.

## Output
Summary / Process map / Findings by severity / Evidence / Fix / Validation / Rollback / Residual risk.

## Safety and references
Use the repository's own Electron version and abstractions; never copy an example blindly across versions. Read-only by default. Original workflow informed by Electron security guidance: https://www.electronjs.org/docs/latest/tutorial/security (consulted 2026-10-18); no upstream text or code copied. For JustCode (a VS Code-derived repo), inspect its actual process and extension-host boundaries first; do not create a JustCode agent.
