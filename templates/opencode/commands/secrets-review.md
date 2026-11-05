---
description: Audit tracked files and configuration for secret exposure and unsafe tool onboarding.
agent: devsecops-agent
---

Audit `$ARGUMENTS` using `skills/security/secrets-audit/SKILL.md`. Do not read protected secret files unless explicitly requested, and never print full secret values. Return redacted evidence, rotation-first fixes, validation, and residual risk.
