---
name: security-policy-testing
description: Test authorization, admission, and infrastructure policies using adversarial fixtures and regression gates.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Security Policy Testing

## Inputs
Policy definitions, trust model, approved access matrix, sample resources, exception inventory, and enforcement mode.

## Workflow
1. Turn each requirement into allowed, denied, missing-attribute, and boundary test cases.
2. Add tests for wildcard access, inheritance, expired exceptions, malformed input, and policy conflicts.
3. Run deterministic tests in CI plus staged shadow decisions; compare changes against baseline and owner sign-off.
4. Gate enforcement on zero critical false allows and understood false denies.

## Validation
Prove tests fail under a deliberately weakened policy; audit exception expiry and log redaction.

## Rollback and safety
Do not change enforcement mode in production without approval. Preserve last-good policy and revert on legitimate access regression; never use live credentials or sensitive user data in fixtures.
