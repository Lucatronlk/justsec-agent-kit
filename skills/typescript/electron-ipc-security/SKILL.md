---
name: electron-ipc-security
description: Review and design Electron IPC and preload bridges for least privilege. Use for ipcMain/ipcRenderer, contextBridge, webview messages, navigation-triggered actions, or renderer access to files, shell or credentials.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# electron-ipc-security

## Purpose and scope
Treat every renderer and child frame as an untrusted caller. Guard the boundary between renderer, preload and main; `electron-typescript` owns general app design and `typescript-untrusted-input` owns shared runtime parsing. Types on either side of IPC do not establish identity or authority.

## Inputs
Electron version, channel map, preload/contextBridge exposure, `ipcMain.handle`/`ipcMain.on` listeners, window/frame origins, permissions, navigation policy, sensitive resource targets and negative tests.

## Workflow
1. Inventory each channel: sender and frame, origin, payload, privileged action/result, authorization basis, lifecycle. Include `ipcMain.on` **and** `ipcMain.handle`, secondary windows, iframes, webviews and any extension-host bridge.
2. Validate `event.senderFrame` (including null/destroyed frames) against the intended window/frame **and** trusted origin or app protocol; an origin string alone may be insufficient for a shared origin. Reject unexpected frames before parsing or touching a resource. Do not rely only on a channel name, TypeScript interface or renderer-provided role/ID. Re-check authorization for each request.
3. Accept bounded `unknown` payloads and validate action-specific shape and path/URL/tenant scope in main. Avoid generic `execute(command, args)`, arbitrary file read, navigation or shell dispatch. Restrict sensitive results to minimum fields and prevent leakage into logs.
4. In preload, expose explicit methods with `contextBridge`, not raw `ipcRenderer`, its `on` method, event objects or a generic channel dispatcher. For subscriptions, strip the event argument and return a disposer; clean up listeners on window destruction. Do not expose an IPC event object through callbacks.
5. Check renderer sandbox, contextIsolation, disabled Node integration and webSecurity. Deny unexpected navigation/window creation, validate external URL protocol/origin before `shell.openExternal`, and scope permission requests. Treat CSP as defense in depth, not authorization.
6. Test allowed caller, unexpected window/iframe, null senderFrame, malformed/oversized payload, wrong tenant/role, navigation-origin change and post-dispose calls. Tests must show rejection before the sensitive sink; record any case that cannot be exercised.

## Validation checklist
- [ ] Every IPC receiver checks actual sender/frame and authorization before side effects.
- [ ] Preload grants only narrowly typed operations, never raw Electron/Node or a generic IPC escape hatch.
- [ ] Invalid payloads and unauthorized frames fail closed; negative tests verify this.
- [ ] Secret results, file paths and shell operations have independent per-operation restrictions.
- [ ] Renderer isolation, sandbox and navigation policy were inspected; exceptions escalated to `devsecops-agent`.

## Output
Channel/privilege inventory / Findings by severity / Evidence (file:line) / Fix / Validation (negative tests) / Rollback / Residual risk.

## Safety and references
Review or test locally only; never probe production desktop installations or read user credentials without authorization. Original checklist informed by Electron security recommendations 2–4, 13–15 and 17–20: https://www.electronjs.org/docs/latest/tutorial/security (consulted 2026-10-18); no upstream text or code copied. For VS Code-derived apps check fork-specific IPC abstractions rather than assuming direct `ipcMain` usage.
