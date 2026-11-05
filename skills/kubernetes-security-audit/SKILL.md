---
name: kubernetes-security-audit
description: Audits Kubernetes manifests, Helm charts, RBAC, and network policy when workload security review is requested.
---

# kubernetes-security-audit

## When To Use

Use for Kubernetes manifests, Helm charts, RBAC, network policy, ingress, secrets, and workload security reviews.

## Workflow

1. Identify manifests, charts, and effective workload types.
2. Review RBAC, service accounts, pod security context, and privilege escalation controls.
3. Check ingress, service exposure, image pinning, probes, and resource limits.
4. Review secret references, encryption assumptions, and auditability.
5. Recommend the smallest safe patch.

## Validation Commands

- `helm lint <chart>`
- `kubectl apply --dry-run=client -f <path>`
- `kubeconform` or `kubeval` if available

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
