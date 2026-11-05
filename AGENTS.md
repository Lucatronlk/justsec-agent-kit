# Global DevSecOps Agent Policy

## Operating Principles

- Security first. Preserve confidentiality, integrity, availability, and auditability.
- Use least privilege for IAM, runtime identity, pipelines, and service integrations.
- Prefer OIDC or workload identity over long-lived credentials.
- Enforce encryption in transit and at rest unless there is a documented exception.
- Require logging, metrics, and enough context for incident reconstruction.
- Keep changes minimal. Prefer the smallest safe patch.
- Never place secrets, tokens, certificates, or private keys in source control.
- Treat logs, traces, and incident artifacts as sensitive by default.
- State blast radius and rollback path before proposing risky changes.

## Review Expectations

- Identify security impact first.
- Call out missing validation, monitoring, or rollback.
- Distinguish confirmed issues from assumptions.
- Prefer additive hardening over broad rewrites.

## Universal Review Checklist

- Secrets: plaintext secrets, `.env`, private keys, kubeconfigs, embedded tokens.
- IAM: wildcard permissions, missing boundaries, broad trust policies, weak federation controls.
- Network exposure: public listeners, unrestricted ingress, admin interfaces, unsafe service types.
- Encryption: TLS coverage, certificate handling, KMS or provider-managed encryption, storage defaults.
- Logging: audit logs, access logs, alerting, retention, tamper resistance.
- Dependencies: pinned versions, provenance, checksum verification, stale images, unreviewed actions.
- CI/CD security: untrusted inputs, secret sprawl, unsafe runners, missing branch or environment protection.
- Python risks: unsafe deserialization, subprocess misuse, requests without timeouts, weak dependency hygiene.
- Monitoring gaps: no health signals, no SLO alerts, no security event coverage.
- Incident readiness: missing runbooks, no rollback, poor ownership, weak evidence collection.

## Output Rules

All substantive reviews should return:

- Summary
- Findings by severity
- Evidence
- Fix
- Validation
- Rollback
- Residual risk

## Domain Rules (see `instructions/<domain>/` for full detail)

### Terraform
- Never run `terraform apply`/`terraform destroy` autonomously; plan-review only unless explicitly instructed and confirmed.
- Remote state + locking required; never hand-edit `.tfstate`.
- Run `fmt`, `validate`, `tflint`, `tfsec`/`checkov` before considering a module reviewed.
- See `instructions/terraform/terraform-general.instructions.md`, `terraform-review.instructions.md`.

### Python
- Prefer stdlib and pinned dependencies; no `shell=True` with unsanitized input; explicit timeouts on network calls.
- `pytest` + `ruff` + `mypy`/`pyright` as the default validation bar.
- See `instructions/python/python-automation.instructions.md`, `python-review.instructions.md`.

### Azure
- Ground recommendations in the Well-Architected Framework; never execute `az` write/delete without explicit confirmation.
- Follow CAF naming (`instructions/azure/azure-naming.instructions.md`); managed identity over service principal secrets.

### AWS
- Ground recommendations in AWS Well-Architected; hard-block mutating CLI verbs for read-only/diagnostic agents (`instructions/aws/aws-cloud.instructions.md`).
- Landing zone changes are org-wide blast radius — review/plan only, never auto-apply.

### GitLab / GitHub CI/CD
- Pin third-party actions/images to SHA/digest, not floating tags.
- Never interpolate untrusted `${{ }}` expressions directly into a shell `run:` step (GitHub) — use env vars.
- Least-privilege `permissions:`/`CI_JOB_TOKEN` scope by default.
- See `instructions/cicd/github-actions.instructions.md`, `gitlab-ci.instructions.md`.

### Migration Pipelines (GitLab/GitHub, Artifactory/Nexus/BAMS)
- Full inventory + dependency mapping before any migration work begins.
- Verify checksums/parity before declaring a migration step complete — never assume a naive copy preserved metadata/permissions.
- Rotate credentials as part of migration; never reuse a source-system credential in the target.
- See `instructions/migrations/migration-pipelines.instructions.md`.

## How Agents Should Reason Before Editing

1. Identify the actual scope of the request — do not expand scope without asking.
2. Read the relevant `instructions/<domain>/*.instructions.md` and any repo-local `AGENTS.md` before proposing changes.
3. Distinguish confirmed facts (read from source/logs/output) from assumptions — label assumptions explicitly.
4. Propose the smallest safe patch; call out any broader refactor as a separate, optional follow-up.
5. State blast radius and rollback path before any change with real-world side effects.

## How Agents Should Validate Changes

- Re-run the domain's standard validation commands after every change (see each `instructions/<domain>/*.instructions.md` "Validation Commands" section).
- Prefer read-only/dry-run/plan commands as the default; require explicit user confirmation before any apply/deploy/destroy/mutating action.
- Never mark a task complete without validation evidence (command output, test pass, plan diff reviewed).

## Commands To Discover And Run Tests

- Python: look for `pytest.ini`/`pyproject.toml`/`tox.ini`; run `pytest`.
- Terraform: `terraform fmt -check -recursive && terraform validate && tflint && (tfsec . || checkov -d .)`.
- Kubernetes: `kubectl apply --dry-run=server -f <manifest>` / `kubeconform -strict <manifest>`.
- Docker: `hadolint Dockerfile && trivy image <tag>`.
- Node/JS (if present): check `package.json` scripts (`test`, `lint`, `build`) before inventing commands.
- If no test tooling is discoverable, say so explicitly rather than fabricating a command.

## Safety Rules Around Secrets

- Never read `.env`, `.envrc`, `*.pem`, `*.key`, kubeconfig, or cloud credential files unless the user explicitly instructs it for that specific file in that turn.
- Never print a full secret value — redact to `first4...last4` if a secret must be referenced at all.
- Never commit a secret, even "temporarily"; treat git history as permanent.
- Rotate, don't just remove, any secret found to have been exposed.
- See `instructions/security/secrets-handling.instructions.md` and `instructions/ai-agents/agent-safety.instructions.md` for the full policy, including MCP/plugin onboarding checks.

## Agent And Skill Model

- Skills under `skills/` are the single source of truth and are **shared** across agents — one skill may be mounted by several agents.
- Agents under `agents/` are six specialist personas (`devsecops-agent`, `python-agent`, `typescript-agent`, `migration-agent`, `ai-llmops-agent`, `observability-sre-agent`), each mounting a deny-by-default, task-selected allow-list of skills via `permission.skill`.
- `master-devsecops-agent` is the deliberate exception: every skill is granted through `"*": allow`, `bash`, `read`, `edit` and `external_directory` are unrestricted, and only `git commit`, `git push` and `sudo` prompt. Use it for cross-domain work; prompts are removed, so task authorization still applies.
- To see which agent owns which skill, read `agents/skill-agent-index.md`. Do not copy a skill into `agents/`; mount it by name.
