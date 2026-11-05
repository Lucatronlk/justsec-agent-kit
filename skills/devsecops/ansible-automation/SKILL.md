---
name: ansible-automation
description: Build idempotent Ansible roles and playbooks with safe inventories, check-mode gates, and controlled rollout.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Ansible Automation

## Inputs
Inventory groups, desired host state, supported OS versions, role dependencies, vault references, and maintenance windows.

## Workflow
1. Separate environments and least-privilege connection/become settings; pin collection versions.
2. Write idempotent tasks with handlers, guarded conditions, and explicit expected file/service state.
3. Run syntax/lint and check mode on a representative host; stage serial canary execution with diff review.
4. Capture change results and post-run service health per host.

## Validation
Second run should report zero changes; confirm service readiness and rollback path on canary before widening rollout.

## Rollback and safety
No unrestricted production playbook runs without approval. Never output vault values or use plain-text secrets; preserve previous config packages and restore/restart on failed canary.
