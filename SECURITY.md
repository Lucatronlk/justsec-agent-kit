# Security Policy

## Supported versions

This repository is a documentation-and-script kit, not a running service. Only the current `main` branch is supported. There is no backport branch.

## What is in scope

- A skill's bundled script doing something its `SKILL.md` does not describe.
- A way to load a skill an agent is not granted.
- A path that escapes the documented scope, or a permission rule that fails open.
- A secret, token, or credential committed to the tree.
- A validation gate that passes when it should fail.

## What is out of scope

- Insecure third-party tooling the skills *describe* (terraform, kubectl, Trivy, and so on).
- A skill's example command being destructive when a human runs it unmodified — examples are templates, not guarantees.
- Vulnerabilities in the host agent (OpenCode, Copilot, Claude Code) itself.
- Anything requiring an account, cluster, or cloud credentials to reproduce.

## Reporting

Use GitHub's private vulnerability reporting: **Security → Report a vulnerability**. Do not open a public issue for a suspected vulnerability.

Include: the affected path, the agent or skill involved, the exact command or payload, and the observed versus expected behaviour.

## Response

Best effort, no SLA and no bounty. Expect an acknowledgement within about a week. Confirmed findings get a fix on `main`; anything that exposed a secret also gets a rotation recommendation, because removing it from the tree does not undo exposure.

## Security model in one paragraph

Skills are Markdown plus optional scripts. `permission.skill` is deny-by-default per agent, but a loaded skill inherits the agent's tool surface. `bash: ask` is an approval prompt, **not a sandbox**: once you approve a command, it runs with your account's filesystem rights. Credential paths are denied for `read` and `edit` by glob only, and a shell command can still read them. Treat skill examples as untrusted input, not as instructions.
