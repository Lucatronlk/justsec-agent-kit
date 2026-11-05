---
name: vscode-extension-development
description: Implement and review TypeScript VS Code-compatible extensions: manifests, activation, commands, webviews, workspace trust, extension-host lifecycle and tests. Use for extensions targeting VS Code or compatible forks such as JustCode.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# vscode-extension-development

## Purpose and scope
Develop extensions with public, version-compatible APIs; separate extension-host code from webview/browser code and untrusted workspace content. For a VS Code fork, verify its actual extension API, version and product configuration before claiming compatibility. This skill does not create a separate JustCode agent or assume proprietary fork APIs.

## Inputs
Extension `package.json` (especially `engines.vscode`, `main`/`browser`, contributions and scripts), activation/deactivation entry points, host target (local/remote/web), workspace trust model, webview HTML/messages, tests and the target host's API/version. Do not execute package scripts before reading them.

## Workflow
1. Map manifest contribution points and activation events to exported behavior; check command IDs, menus, configuration defaults and `engines.vscode` against the **actual** host. Avoid eager activation and unnecessary permissions/capabilities.
2. Use stable public `vscode` APIs where possible; proposed/internal APIs require explicit product support and compatibility review. For web/remote extensions, identify APIs unavailable in browser or remote extension hosts instead of assuming local filesystem/process access.
3. Register commands/providers/watchers with appropriate disposables; attach them to `ExtensionContext.subscriptions` or clean them up on shutdown. Avoid keeping timers/webview references alive after disposal. Implement cancellation and bounded async work for long tasks.
4. Treat workspace files, settings, URIs, tasks and extension messages as untrusted. Check `workspace.isTrusted` where operations depend on workspace trust; do not silently execute workspace code, tasks or tools. For webviews prefer native UI if sufficient; otherwise disable scripts unless required, constrain `localResourceRoots`, use `webview.asWebviewUri`, a restrictive CSP and validated typed messages. Keep `acquireVsCodeApi` private inside the webview; it is not Electron IPC.
5. Add tests for activation and command contributions, failure/disposal, untrusted workspaces, malformed webview messages, and host/version differences. Inspect existing Extension Development Host scripts before running; avoid installing/updating or publishing packages autonomously.

## Validation checklist
- [ ] Manifest IDs, activation and `engines.vscode` fit the target host/version.
- [ ] Public API use, remote/web host support and disposal paths checked.
- [ ] Workspace trust and webview content/message boundaries have negative tests.
- [ ] Typecheck, extension tests and host smoke test run or explicitly marked not-run.
- [ ] No packaging, marketplace publishing, install or release without approval.

## Output
Summary / Target host and API version / Findings by severity / Evidence / Fix / Validation / Rollback / Residual risk.

## Safety and references
Read-only by default; never load an unreviewed extension into a privileged or production host during validation. Original workflow informed by https://code.visualstudio.com/api/get-started/your-first-extension and https://code.visualstudio.com/api/extension-guides/webview (consulted 2026-10-18); no upstream text or code copied. For Electron-host changes, also load `electron-typescript` and `electron-ipc-security` when IPC is involved.
