# Migration Pipelines Instructions

> **Mostly authored by us.** Neither source repo contains Artifactory/Nexus/GitLab-GitHub repository-migration tooling (confirmed via exhaustive review — `awesome-opencode` explicitly has zero migration tooling; `awesome-copilot`'s only adjacent asset is `agents/jfrog-sec.agent.md`, a JFrog Curation/security-compliance agent, and the generic `skills/import-infrastructure-as-code` brownfield-IaC-import workflow, whose phased/verify-before-declare-done discipline is reused below).

## When To Use

Planning or executing migrations: GitLab↔GitHub, Artifactory/Nexus repository migrations, BAMS/binary-artifact migrations, or any cross-platform CI/CD cutover.

## Phased Migration Discipline

1. **Inventory**: enumerate every artifact/repo/pipeline/permission/webhook/secret that must move. Do not start copying before the inventory is complete and reviewed.
2. **Dependency mapping**: identify what depends on what (pipeline → package registry → downstream consumer) before touching anything.
3. **Dry-run / mirror phase**: stand up the target system as a read-only mirror first; validate content parity (checksums, package counts, tag counts) before any traffic cutover.
4. **Dual-write / bridge phase** (if long cutover window): both systems receive writes, source remains authoritative, target validated continuously.
5. **Cutover**: flip authoritative source only after validation checklist passes; keep the old system read-only (not deleted) for a rollback window.
6. **Decommission**: only after a defined bake period with zero rollback incidents.

## Artifact/Repository Migration Specifics (Artifactory/Nexus/BAMS)

- Verify checksums (SHA-256) of every migrated artifact against the source — do not trust a "copy succeeded" status alone.
- Migrate metadata (retention policies, permissions, virtual/remote repo layouts) explicitly — these rarely transfer via a naive file copy.
- For package-registry migrations (npm/Maven/PyPI/Docker), validate that consumer pipelines can actually resolve packages from the new location before decommissioning the old one (test a real build against the new registry).
- Treat repository credentials/API keys as migration artifacts requiring rotation, not carry-over — never reuse the same long-lived token across old and new systems.

## GitLab ↔ GitHub Migration Specifics

- Branch protection, required reviewers, and environment protection rules do not migrate automatically — recreate explicitly (manually, via API, or via Terraform `github`/`gitlab` providers) and verify parity before cutover.
- CI/CD pipeline syntax must be translated, not copy-pasted (see `cicd/gitlab-ci.instructions.md` mapping table).
- Issues/MRs/PRs history migration (if required) should preserve authorship and timestamps where the tooling supports it (e.g., `gh gei`, GitLab's project export/import); validate a sample set for fidelity before bulk migration.
- Webhooks and integrations (Slack, Jira, monitoring) must be re-registered on the target platform explicitly.

## Verification-Before-Done Rule (borrowed from IaC import discipline)

- Never declare a migration "complete" until an explicit, reproducible verification step shows parity (e.g., artifact count match, checksum match, a real build/pipeline run succeeding end-to-end on the target).
- Do not write migration scripts from memory of "how the API probably works" — read the actual target platform's migration/import API docs and test against a non-production project first.

## Output Format

- Summary
- Migration plan (phases above)
- Risks / rollback plan per phase
- Validation evidence
- Residual risk

## Safety Notes

- Never delete the source system/repo until the decommission bake period has passed with no rollback.
- Never reuse a credential across source and target systems — rotate as part of migration, not after.
- Treat any migration script touching production artifact stores as high blast-radius — dry-run first, require explicit human approval before a destructive step (delete/overwrite).
