---
name: k8s-manifest-review
description: Reviews Kubernetes manifests and Helm charts for security and reliability when deployment configuration changes are requested.
---

# k8s-manifest-review

## Purpose
Review Kubernetes manifests/Helm charts for security, reliability, and best-practice compliance before apply.

## When To Use
- New or changed Kubernetes manifests/Helm chart values.
- Pre-production deployment review.
- Periodic cluster-config audit.

## Inputs Expected
- Manifest YAML / Helm chart + values, or a live namespace to inspect (read-only `kubectl get`).

## Step-By-Step Process
1. Validate syntax/schema: `kubectl apply --dry-run=server -f manifest.yaml`, `kubeconform -strict manifest.yaml`.
2. Check security defaults: `runAsNonRoot`, `allowPrivilegeEscalation: false`, `readOnlyRootFilesystem`, capabilities dropped, no `privileged: true` without justification.
3. Check secrets handling: no plaintext secrets in ConfigMaps/env vars; `Secret` objects or external-secrets integration used.
4. Check reliability: replica count ≥2-3 for production, `PodDisruptionBudget`, anti-affinity, resource `requests`/`limits`, liveness/readiness probes present.
5. Check image hygiene: pinned by digest (not `:latest`) for production, scanned for CVEs in CI.
6. Check RBAC/NetworkPolicy: least-privilege roles, default-deny NetworkPolicy with explicit allows.
7. Produce severity-ranked findings and the smallest safe patch.

## Validation Checklist
- [ ] `kubectl apply --dry-run=server` passes
- [ ] Security context hardened (non-root, no privilege escalation, capabilities dropped)
- [ ] Secrets not stored in ConfigMaps/plaintext env
- [ ] Resource requests/limits and probes present
- [ ] Replica count/PDB/anti-affinity appropriate for environment
- [ ] Image pinned by digest for production; scanned in CI
- [ ] RBAC least-privilege, NetworkPolicy present

## Output Format
- Summary
- Findings by severity
- Evidence (manifest path/line)
- Fix
- Validation
- Rollback (`kubectl rollout undo` or equivalent)
- Residual risk

## Safety Notes
- Review only — never `kubectl apply`/`delete` against a live cluster as part of this skill without explicit, separate approval.
- Always confirm `kubectl config current-context` before any suggested live command to avoid targeting the wrong cluster.

Related instructions: `instructions/kubernetes/kubernetes-best-practices.instructions.md`
