---
name: gitlab-migration
description: Migrate GitLab projects and CI with repository, identity, runner, registry, and approval-rule parity checks.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# GitLab Migration

## Inputs
Source/target GitLab versions, project/group inventory, LFS, submodules, protected refs, merge approvals, runners, CI variables metadata, registry, webhooks, and issues.

## Workflow
1. Discover groups, membership, project settings, branches/tags, pipelines, integrations, package/registry and issue scope.
2. Plan export/import or mirror path, API/version limits, identity mapping, runner executor parity, variable recreation, and URL redirects.
3. With approval, pilot project; import/mirror in waves, pause or coordinate writes, switch webhooks and runners at cutover.
4. Validate Git refs/LFS hashes, permissions/approvals, MR/issue counts where scoped, CI jobs, registry pulls, and webhook delivery.
5. Monitor failed pipelines and missing refs during bake period.

## Rollback and safety
Retain source project and known-good pipeline/runner settings; route pushes and webhooks back only after reconciling divergent commits. Do not export CI variable values or delete source before sign-off; production mutation needs approval.

## Readiness, parity and release gates
- Inventory all scoped groups/projects, refs and Git object IDs, LFS objects, submodules, protected refs, approvals, members/roles, CI variables **names/scopes only**, runners, hooks, integrations, packages/registry, issues/MRs/wikis and consumers/owners. Map dependencies (external CI, deploy keys, submodule URLs, downstream builds) and explicit export/API/version gaps; record a dated baseline and freeze/delta watermark.
- Stage a read-only mirror for target validation and pilot a bounded project with approval. Obtain separate explicit production import and cutover approvals, change window, tested backup/restore, owners, rollback time and plan for new scoped target tokens/credentials (never reuse or export source values). No production mutation is authorized by this skill.
- At frozen/final-delta boundary compare **every** scoped ref name and object ID (or documented equivalent content digest if history is rewritten), complete LFS OID/size lists and submodule references, project/group/settings inventories, memberships and approval rules. Compare per-project issue/MR/wiki and registry/package inventories with full path/version/digest where APIs allow; require zero unexplained missing/extra/mismatched records. API visibility, history rewrite, inaccessible package digests, export limitations and approved exclusions must be explicit; sampling does not prove exhaustive integrity. Run real end-to-end target pipeline per runner/consumer class, test registry pulls and webhook delivery and verify allow/deny protections without exposing variables.
- Store timestamped redacted manifests/comparison results, pipeline IDs, delivery logs, approvals and exceptions. Go/no-go requires scoped parity, test pass, credential rotation readiness and pre-agreed failed-pipeline/missing-ref/webhook thresholds through defined bake period. If failed, stop target writes/webhooks, reconcile divergent commits/packages/issues first, redirect writes and hooks to retained source exactly once, restore known-good runner settings and rerun parity; never disable integrity verification or delete source until bake and owner sign-off.
