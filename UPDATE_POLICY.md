# Shared Platform Update Policy

## Evolution Rules

- Update the shared platform deliberately.
- Prefer additive changes.
- Keep standards stable unless there is a clear governance reason to change them.

## Repo Safety Rules

- Do not overwrite repo-specific logic.
- Do not replace existing `AGENTS.md` content.
- Add local overrides in repo files rather than forking the shared platform without reason.

## Recommended Update Flow

1. Change shared docs, skills, scripts, or templates in `justsec-agent-kit`.
2. Review impact on existing repositories.
3. Roll out only missing or explicitly approved repo-local updates.
4. Validate before wider propagation.

## Drift Management

- Keep repo-local files minimal and specific; add local overrides in repo files rather than forking the shared platform.
- **Never symlink files into a repo that carries them to other machines.** Git stores the link, not the content: every other machine that pulls gets a dangling link to a path that does not exist there, and a secret scan sees a link target string rather than the file text. Symlinks are fine only for same-machine mounts where the target always exists.
- **Copy real files, and detect drift.** A repo that copies `justsec-agent-kit` content should be able to answer, read-only, which files are ours, which are stale, and which were edited. Periodically audit repos for stale agent instructions.

### Content-Bound Markers

> Pattern borrowed from `ChiefGyk3D/department-of-internal-arguments` (MIT, © 2026 ChiefGyk3D): the marker-plus-body-hash ownership model. Not copied verbatim.

Every file written into a repo by the sync process carries one marker line:

```
<!-- Generated for justsec-agent-kit (release R) from SOURCE. sha256:HEX. Do not edit; re-run the sync. -->
```

`HEX` is the sha256 of the file **with that one line removed** (the body). The core property: **the marker alone proves nothing.**

- A destination is **platform-owned** only when the marker is well-formed (exactly one, strictly parsed) *and* the body still hashes to `HEX`. Marker text pasted into a hand-edited file is not ownership.
- `--update` replaces a file only when it is platform-owned; anything else is a collision and the whole install stops before writing.
- An **edited** file (marker present, body mismatched) is refused, not overwritten, unless explicitly forced; never widen a file's permissions on update.
- The hash binds content to the marker; it is **not a signature** — anyone who can write the file can write a matching hash. Review the preview and the diff, which remain the real control.

### Drift Statuses (read-only report)

A `--list-managed`-style check reports, per file: its release, its source, and one status:

| Status | Meaning |
|---|---|
| `current` | this release, body matches its hash |
| `stale` | an older release |
| `differs` | this release, but the body changed |
| `orphan` | this checkout no longer produces it |
| `edited` | marker present but the body does not match the hash |
| `unchecked` | overlay-sourced and no overlay was supplied |

Exit `0` when everything is `current`, non-zero on any drift, so a sync step can report and decide rather than write blind.
