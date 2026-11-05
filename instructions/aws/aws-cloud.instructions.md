# AWS Cloud Instructions

> Adapted from `awesome-copilot` (`agents/aws-cloud-expert.agent.md`, `agents/aws-incident-triage.agent.md`, `skills/aws-resource-query`, `skills/aws-well-architected-review`). Converted to generic Markdown.

## When To Use

Any AWS architecture, incident, cost, or governance task.

## Principles

- Ground recommendations in the AWS Well-Architected Framework (Security, Reliability, Performance Efficiency, Cost Optimization, Operational Excellence, Sustainability).
- Never suggest hardcoded credentials — use IAM roles, Secrets Manager, or SSM Parameter Store (SecureString).
- Flag anything that widens the security posture: public S3 buckets, `0.0.0.0/0` security group ingress, wildcard IAM policies.

## Safe Query Contract (adapted from `aws-resource-query` — recommended pattern for ANY cloud agent)

When an agent only needs to inspect/report on AWS resources, hard-block mutating verbs:

```
NEVER run: create-*, run-*, start-*, stop-*, reboot-*, delete-*, terminate-*, put-*, update-*, modify-*, attach-*, detach-*, authorize-*, revoke-*
Never call get-secret-value or get-parameter for secret values — metadata only.
```

Adopt this same contract for Azure (`az ... show/list` only) and GCP equivalents when building a read-only diagnostic agent.

## Incident Triage Workflow (adapted from `aws-incident-triage`)

1. Read-only by default. Never mutate infrastructure without explicit approval.
2. Narrow blast radius: Account → Region → Service → Operation → Resource.
3. Pull CloudWatch Logs Insights + metrics for the incident window:
   ```
   fields @timestamp, @message, @logStream
   | filter @message like /(?i)(error|exception|fatal|critical)/
   | stats count(*) as errorCount by bin(5m), @logStream
   ```
4. Correlate with CloudTrail for recent control-plane changes.
5. Escalate immediately on suspected data loss.

## Well-Architected Review Checklist (condensed)

- [ ] IAM roles use least-privilege policies (no bare `*` actions without justification).
- [ ] GuardDuty enabled (`aws guardduty list-detectors`).
- [ ] AWS WAF configured on public-facing APIs / CloudFront.
- [ ] S3 buckets: public access block enabled by default.
- [ ] Encryption at rest (KMS) for EBS, S3, RDS, DynamoDB.
- [ ] CloudTrail enabled organization-wide, log file validation on.
- [ ] Config rules / Security Hub enabled for continuous compliance.

## Safety Notes

- Remediation commands (e.g. `aws lambda put-reserved-concurrency`, `aws rds reboot-db-instance`) are suggestions only — require human approval before running.
- Never retrieve or print secret values from Secrets Manager / Parameter Store.
