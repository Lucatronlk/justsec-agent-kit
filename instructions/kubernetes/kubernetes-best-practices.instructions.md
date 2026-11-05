# Kubernetes Best Practices Instructions

> Condensed from `awesome-copilot` (`instructions/kubernetes-deployment-best-practices.instructions.md`, `instructions/kubernetes-manifests.instructions.md`, `agents/platform-sre-kubernetes.agent.md`). Converted to generic Markdown.

## When To Use

Authoring or reviewing Kubernetes manifests, Helm charts, or cluster configuration.

## Security Defaults (Non-Negotiable)

```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
```

- No `privileged: true` containers without an explicit, documented, owner-approved exception.
- Secrets via `Secret` objects (or external-secrets/Vault integration) — never plaintext in ConfigMaps or env vars in plain manifests committed to git.
- Network Policies default-deny, explicit allow rules per namespace/workload.
- RBAC: least-privilege `Role`/`ClusterRole` bindings; avoid `cluster-admin` for workload service accounts.

## Reliability

- 2-3+ replicas for production workloads; `PodDisruptionBudget` set.
- Anti-affinity rules to spread replicas across nodes/zones.
- Liveness and readiness probes on every container — a missing readiness probe is a rollout-safety gap.
- Resource `requests`/`limits` set on every container — no unbounded workloads.
- Pin images by digest (`image@sha256:...`) for production, not just a tag, to guarantee immutability.

## Manifest Hygiene

- Standard labels: `app.kubernetes.io/name`, `app.kubernetes.io/instance`, `app.kubernetes.io/version`, `app.kubernetes.io/managed-by`.
- Pod Security Admission: apply `restricted` or `baseline` profile per namespace; avoid `privileged` namespaces except for system components.
- Validate before apply: `kubectl apply --dry-run=server -f manifest.yaml`, `kubeconform -strict manifest.yaml`.
- Policy enforcement via OPA/Gatekeeper or Kyverno for org-wide guardrails (e.g., "no `:latest` tags", "must have resource limits").

## Image Scanning

- Scan images in CI (Trivy/Clair/Snyk) before push to registry; fail the pipeline on Critical/High CVEs without an approved exception.

## Rollout Strategy

- Rolling update by default; blue-green/canary for high-risk production services.
- Always have a rollback plan: `kubectl rollout undo deployment/<name>`.
- Never deploy a risky change immediately before a period of low on-call coverage (e.g., late Friday) without extra readiness.

## Validation Commands

```bash
kubectl apply --dry-run=server -f manifest.yaml
kubeconform -strict manifest.yaml
kubectl rollout status deployment/<name>
```

## Safety Notes

- Never disable a Pod Security Admission policy or Network Policy to "unblock" a deployment without explicit, documented approval.
- Never apply directly to a production cluster context without confirming `kubectl config current-context` first.
