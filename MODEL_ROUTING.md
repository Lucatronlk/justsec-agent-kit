# Model Routing

## Use Codex When

- the task spans multiple files or repositories
- architecture decisions are required
- Terraform or cloud infrastructure changes are involved
- Kubernetes, Helm, or manifest changes are involved
- CI/CD pipelines or supply-chain controls are being changed
- a review must connect code, config, and operational impact

## Use Ollama When

- logs or incident notes should stay local only
- code or artifacts are especially sensitive
- you need a smaller targeted analysis
- you are summarizing a local incident or triage thread
- the task is narrow and does not require broad cross-repo reasoning

## Hybrid Pattern

1. Use Codex to scope impact, classify the repo, and determine the review path.
2. Use Ollama for sensitive logs or local-only evidence.
3. Return to Codex to propose minimal safe changes and consistent documentation.

## Guardrails

- Never move secrets or sensitive logs into prompts unnecessarily.
- Minimize copied evidence.
- Prefer summaries and redactions over raw sensitive payloads.
