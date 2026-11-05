---
name: kubernetes-admission-policy
description: Design and test Kubernetes admission controls for workload security without blocking critical deployments.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Kubernetes Admission Policy

## Inputs
Cluster versions, admission engine, workload manifests, namespace labels, exemption owners, and failure policy.

## Workflow
1. Inventory existing PSA, ValidatingAdmissionPolicy, Kyverno, or Gatekeeper controls and webhook availability.
2. Define scoped policies for images, privileges, resources, and registries with explicit exception expiry.
3. Dry-run against representative workloads and test malformed objects, webhook downtime, and upgrade compatibility.
4. Start audit mode, review violations, then stage enforcement by namespace with monitoring.

## Validation
Verify denied bad pods and admitted good pods plus webhook latency and availability; measure false-denial rate.

## Rollback and safety
Do not enforce cluster-wide without approval. Maintain last-good policy and break-glass plan; revert enforcement on blocked critical workloads. Never put credentials in policy parameters.
