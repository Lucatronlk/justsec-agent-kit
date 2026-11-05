---
name: pipeline-security-review
description: Reviews GitHub Actions and GitLab CI pipelines for injection, secrets, and supply-chain risks when workflows change.
---

# pipeline-security-review

## Purpose
Review a CI/CD pipeline (GitHub Actions or GitLab CI) for supply-chain, injection, and secrets-handling risk.

## When To Use
- New or changed pipeline/workflow file.
- Periodic CI/CD security audit.
- Onboarding a new repo into shared CI templates.

## Inputs Expected
- `.github/workflows/*.yml` or `.gitlab-ci.yml` source.

## Step-By-Step Process
1. Identify triggers used (`pull_request`, `pull_request_target`, `workflow_run`, `issue_comment`, or GitLab `rules:`/`merge_request_event`) and flag elevated-trust triggers that checkout/execute untrusted code.
2. Search for `${{ }}` expression interpolation directly inside `run:` steps (GitHub) — this is a shell-injection sink, not a safe variable.
3. Check permissions: `permissions:` block scoped to least privilege (GitHub), CI/CD variable `Protected`/`Masked` flags and `CI_JOB_TOKEN` scope (GitLab).
4. Check third-party action/image pinning: SHA-pinned (GitHub) or digest-pinned images (GitLab), not floating tags.
5. Check secret handling: secrets sourced from encrypted secrets/OIDC, never hardcoded; no secret values echoed to logs.
6. Check for missing security gates: SAST, dependency/SCA scanning, secret scanning, container scanning present in the pipeline.
7. **Reusable workflows (GitHub).** The caller must grant every permission and secret the callee declares — callers and callees are validated **statically at parse time**, so a mismatch ends every run in `startup_failure` before any job starts. Diff each callee's declared `permissions:`/`secrets:` against the caller's grants. Confirm third-party reusable workflows are pinned to a tag or SHA, **never a branch** (`@main`).
8. **Artifact and digest binding between jobs.** A job that rescans, publishes or signs must consume the exact bytes an earlier job produced (an image by digest, an SBOM as an uploaded artifact) — not re-pull a mutable tag. An **empty matrix must fail**, not exit successfully having scanned nothing.
9. **Branch protection.** A REST read of `allow_force_pushes` can report `false` while a GraphQL `bypassForcePushAllowances` list still exists, and a REST PUT of `false` does not clear it. Read and clear bypasses through GraphQL (`allowsForcePushes`, `bypassForcePushAllowances`).
10. **Egress control.** Prefer the enforcing/block mode with an explicit allow-list where the platform offers it; an audit/observe mode only reports and blocks nothing.
11. **The pin-guard test itself.** A test asserting pinning must collect matches loosely, assert strictly (including that *something* was collected) and carry a negative case — an unpinned `@main`, a missing `# vX.Y.Z` comment, or a second workflow file that the glob misses.
12. Produce severity-ranked findings with concrete patches.

## Validation Checklist
- [ ] No untrusted `${{ }}` interpolated directly into a shell `run:` step (use `env:` + quoted `"$VAR"`)
- [ ] `permissions:`/token scope least-privilege
- [ ] Third-party actions/images pinned to SHA/digest (never a tag or branch)
- [ ] Reusable-workflow callers grant every permission/secret the callee declares (else `startup_failure`)
- [ ] Third-party reusable workflows pinned to tag/SHA, never `@main`
- [ ] Cross-job artifacts bound to the verified bytes (image by digest); empty matrix fails
- [ ] Branch-protection force-push bypasses read/cleared via GraphQL, not REST alone
- [ ] Egress set to an enforcing mode with an allow-list, not audit-only
- [ ] The pin-guard test collects loosely, asserts strictly, and has a negative case
- [ ] No hardcoded secrets; OIDC/federated auth used for cloud access
- [ ] Elevated-trust triggers (`pull_request_target`, etc.) reviewed for checkout-and-execute risk
- [ ] SAST/SCA/secret-scanning present or explicitly deferred with owner sign-off

## Output Format
- Summary
- Findings by severity
- Evidence (file:line)
- Fix
- Validation
- Rollback
- Residual risk

## Safety Notes
- This skill only reviews pipeline definitions; it does not modify or trigger pipeline runs.
- Never recommend disabling a security gate to unblock a pipeline without flagging the residual risk explicitly.

Related instructions: `instructions/cicd/github-actions.instructions.md`, `instructions/cicd/gitlab-ci.instructions.md`, `instructions/devsecops/devsecops-general.instructions.md`
