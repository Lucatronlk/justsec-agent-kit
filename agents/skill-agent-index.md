# Skill → Agent Index

Authoritative mapping for the six domain agents. Skills live once under `skills/`; each agent has a deny-by-default allow-list and selects skills per task.

- **274 skill files**, **274 indexed unique names**; every file has frontmatter and is indexed.
- **6 agents**; each indexed skill belongs to at least one.
- **104 shared indexed skills** are available to more than one agent.

## Agents

| Agent | File | Skills |
|---|---|---|
| devsecops-agent | `agents/devsecops-agent.md` | 230 |
| python-agent | `agents/python-agent.md` | 32 |
| typescript-agent | `agents/typescript-agent.md` | 60 |
| migration-agent | `agents/migration-agent.md` | 54 |
| ai-llmops-agent | `agents/ai-llmops-agent.md` | 55 |
| observability-sre-agent | `agents/observability-sre-agent.md` | 46 |

## Shared Skills

- `adversarial-review`
- `agent-evals`
- `agent-observability`
- `ai-agent-security`
- `ai-coding-agent-guardrails`
- `ai-inference-service-mesh`
- `ai-pipeline-orchestration`
- `ai-red-teaming`
- `ai-security-hardening`
- `ai-sre-incident-response`
- `alerting-oncall`
- `architecture-mapping`
- `asset-inventory`
- `azure-devops`
- `bola-detector`
- `business-continuity`
- `change-impact-analysis`
- `datadog`
- `dependency-graph`
- `dependency-scanning`
- `disaster-recovery`
- `dockerfile-review`
- `documentation-writer`
- `ebpf-observability`
- `electron-ipc-security`
- `elk-stack`
- `feature-flags`
- `git-workflow`
- `github-actions`
- `gitlab-ci`
- `gitlab-pipeline-review`
- `gpu-kubernetes-operations`
- `gpu-server-management`
- `hashicorp-vault`
- `incident-management`
- `incident-triage`
- `jenkins`
- `llm-app-security`
- `llm-caching`
- `llm-cost-optimization`
- `llm-fine-tuning`
- `llm-gateway`
- `llm-inference-scaling`
- `llmops-platform-engineering`
- `local-llm-routing`
- `log-pipeline-review`
- `loki-logging`
- `mac-mini-llm-lab`
- `mcp-server-security`
- `model-registry-governance`
- `model-serving-kubernetes`
- `model-supply-chain-security`
- `monitoring-observability-review`
- `multi-tenant-llm-hosting`
- `new-relic`
- `ollama-stack`
- `openapi-hardener`
- `openclaw-local-mac-mini`
- `opentelemetry`
- `pipeline-security-review`
- `pipeline-supply-chain-review`
- `planning-and-task-breakdown`
- `pr-risk-summary`
- `prometheus-grafana`
- `prompt-injection-defense`
- `python-async-concurrency`
- `python-debugging`
- `python-development`
- `python-packaging`
- `python-performance`
- `python-project-configuration`
- `python-quality-and-testing`
- `python-refactor`
- `python-security-review`
- `python-untrusted-input`
- `rag-infrastructure`
- `rag-observability-evals`
- `readme-generator`
- `repo-ai-readiness`
- `repo-intelligence`
- `runbook-creation`
- `runbook-generator`
- `sast-scanning`
- `sbom-supply-chain`
- `secrets-audit`
- `semantic-versioning`
- `sops-encryption`
- `sre-dashboards`
- `systematic-debugging`
- `technical-debt-analysis`
- `threat-modeling`
- `typescript-review`
- `understand`
- `understand-chat`
- `understand-dashboard`
- `understand-diff`
- `understand-domain`
- `understand-explain`
- `understand-figma`
- `understand-knowledge`
- `understand-onboard`
- `vector-database-ops`
- `verification-before-completion`
- `vllm-server`

## Full Matrix

| skill | path | agent(s) |
|---|---|---|
| `access-review` | `skills/access-review/SKILL.md` | devsecops-agent |
| `adversarial-review` | `skills/quality/adversarial-review/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `agent-evals` | `skills/ai/agent-evals/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `agent-integration-testing` | `skills/ai/agent-integration-testing/SKILL.md` | ai-llmops-agent |
| `agent-observability` | `skills/ai/agent-observability/SKILL.md` | devsecops-agent, ai-llmops-agent, observability-sre-agent |
| `agent-tool-development` | `skills/ai/agent-tool-development/SKILL.md` | ai-llmops-agent |
| `ai-agent-security` | `skills/security/ai/ai-agent-security/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `ai-coding-agent-guardrails` | `skills/security/ai/ai-coding-agent-guardrails/SKILL.md` | devsecops-agent, typescript-agent, ai-llmops-agent |
| `ai-inference-service-mesh` | `skills/infrastructure/networking/ai-inference-service-mesh/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `ai-pipeline-orchestration` | `skills/ai/ai-pipeline-orchestration/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `ai-red-teaming` | `skills/security/ai/ai-red-teaming/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `ai-security-hardening` | `skills/security/ai/ai-security-hardening/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `ai-sre-incident-response` | `skills/ai/ai-sre-incident-response/SKILL.md` | devsecops-agent, observability-sre-agent |
| `alert-noise-reduction` | `skills/observability/alert-noise-reduction/SKILL.md` | observability-sre-agent |
| `alerting-oncall` | `skills/observability/alerting-oncall/SKILL.md` | devsecops-agent, observability-sre-agent |
| `ansible-automation` | `skills/devsecops/ansible-automation/SKILL.md` | devsecops-agent |
| `architecture-mapping` | `skills/shared/architecture-mapping/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `argocd-gitops` | `skills/orchestration/argocd-gitops/SKILL.md` | devsecops-agent |
| `arm-templates` | `skills/infrastructure/cloud-azure/arm-templates/SKILL.md` | devsecops-agent |
| `artifact-migration-debugging` | `skills/migrations/artifact-migration-debugging/SKILL.md` | migration-agent |
| `asset-inventory` | `skills/asset-inventory/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `audit-logging` | `skills/audit-logging/SKILL.md` | devsecops-agent |
| `aws-cloudtrail` | `skills/aws-cloudtrail/SKILL.md` | devsecops-agent |
| `aws-cost-optimization` | `skills/infrastructure/cloud-aws/aws-cost-optimization/SKILL.md` | devsecops-agent |
| `aws-ec2` | `skills/infrastructure/cloud-aws/aws-ec2/SKILL.md` | devsecops-agent |
| `aws-ecs-fargate` | `skills/infrastructure/cloud-aws/aws-ecs-fargate/SKILL.md` | devsecops-agent |
| `aws-iam` | `skills/infrastructure/cloud-aws/aws-iam/SKILL.md` | devsecops-agent |
| `aws-lambda` | `skills/infrastructure/cloud-aws/aws-lambda/SKILL.md` | devsecops-agent |
| `aws-landing-zone-review` | `skills/aws/aws-landing-zone-review/SKILL.md` | devsecops-agent |
| `aws-rds` | `skills/infrastructure/cloud-aws/aws-rds/SKILL.md` | devsecops-agent |
| `aws-s3` | `skills/infrastructure/cloud-aws/aws-s3/SKILL.md` | devsecops-agent |
| `aws-secrets-manager` | `skills/security/secrets/aws-secrets-manager/SKILL.md` | devsecops-agent |
| `aws-vpc` | `skills/infrastructure/cloud-aws/aws-vpc/SKILL.md` | devsecops-agent |
| `azure-aks` | `skills/infrastructure/cloud-azure/azure-aks/SKILL.md` | devsecops-agent |
| `azure-architecture-review` | `skills/azure/azure-architecture-review/SKILL.md` | devsecops-agent |
| `azure-devops` | `skills/cicd/azure-devops/SKILL.md` | devsecops-agent, typescript-agent |
| `azure-functions` | `skills/infrastructure/cloud-azure/azure-functions/SKILL.md` | devsecops-agent |
| `azure-iac-generation` | `skills/azure/azure-iac-generation/SKILL.md` | devsecops-agent |
| `azure-identity-rbac` | `skills/devsecops/azure-identity-rbac/SKILL.md` | devsecops-agent |
| `azure-keyvault` | `skills/security/secrets/azure-keyvault/SKILL.md` | devsecops-agent |
| `azure-monitor-audit` | `skills/azure-monitor-audit/SKILL.md` | devsecops-agent |
| `azure-networking` | `skills/infrastructure/cloud-azure/azure-networking/SKILL.md` | devsecops-agent |
| `azure-pipelines-review` | `skills/cicd/azure-pipelines-review/SKILL.md` | devsecops-agent |
| `azure-policy-governance` | `skills/devsecops/azure-policy-governance/SKILL.md` | devsecops-agent |
| `azure-security-review` | `skills/azure/azure-security-review/SKILL.md` | devsecops-agent |
| `azure-sql` | `skills/infrastructure/cloud-azure/azure-sql/SKILL.md` | devsecops-agent |
| `azure-vms` | `skills/infrastructure/cloud-azure/azure-vms/SKILL.md` | devsecops-agent |
| `backup-recovery` | `skills/infrastructure/storage/backup-recovery/SKILL.md` | devsecops-agent |
| `backup-validation` | `skills/devsecops/backup-validation/SKILL.md` | devsecops-agent |
| `block-storage` | `skills/infrastructure/storage/block-storage/SKILL.md` | devsecops-agent |
| `blue-green-deploy` | `skills/release/blue-green-deploy/SKILL.md` | devsecops-agent |
| `bola-detector` | `skills/security/api/bola-detector/SKILL.md` | devsecops-agent, typescript-agent |
| `business-continuity` | `skills/business-continuity/SKILL.md` | devsecops-agent, observability-sre-agent |
| `caddy-management` | `skills/devsecops/caddy-management/SKILL.md` | devsecops-agent |
| `cdn-setup` | `skills/infrastructure/networking/cdn-setup/SKILL.md` | devsecops-agent |
| `change-impact-analysis` | `skills/shared/change-impact-analysis/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `change-management` | `skills/change-management/SKILL.md` | devsecops-agent |
| `circleci` | `skills/cicd/circleci/SKILL.md` | devsecops-agent |
| `cis-benchmarks` | `skills/security/hardening/cis-benchmarks/SKILL.md` | devsecops-agent |
| `cloudflare-pages` | `skills/infrastructure/cloudflare/cloudflare-pages/SKILL.md` | devsecops-agent |
| `cloudflare-r2` | `skills/infrastructure/cloudflare/cloudflare-r2/SKILL.md` | devsecops-agent |
| `cloudflare-workers` | `skills/infrastructure/cloudflare/cloudflare-workers/SKILL.md` | devsecops-agent |
| `cloudflare-zero-trust` | `skills/infrastructure/cloudflare/cloudflare-zero-trust/SKILL.md` | devsecops-agent |
| `cloudformation` | `skills/infrastructure/cloud-aws/cloudformation/SKILL.md` | devsecops-agent |
| `compatibility-validation` | `skills/migrations/compatibility-validation/SKILL.md` | migration-agent |
| `container-hardening` | `skills/security/hardening/container-hardening/SKILL.md` | devsecops-agent |
| `container-registries` | `skills/containers/container-registries/SKILL.md` | devsecops-agent |
| `container-scanning` | `skills/security/scanning/container-scanning/SKILL.md` | devsecops-agent |
| `convex-backend` | `skills/infrastructure/platforms/convex-backend/SKILL.md` | devsecops-agent |
| `cutover-rollback` | `skills/migrations/cutover-rollback/SKILL.md` | migration-agent |
| `dast-scanning` | `skills/security/scanning/dast-scanning/SKILL.md` | devsecops-agent |
| `database-backups` | `skills/infrastructure/databases/database-backups/SKILL.md` | devsecops-agent |
| `datadog` | `skills/observability/datadog/SKILL.md` | devsecops-agent, observability-sre-agent |
| `dependency-graph` | `skills/shared/dependency-graph/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `dependency-scanning` | `skills/security/scanning/dependency-scanning/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `devcontainers-nix` | `skills/developer-experience/devcontainers-nix/SKILL.md` | devsecops-agent |
| `disaster-recovery` | `skills/disaster-recovery/SKILL.md` | devsecops-agent, observability-sre-agent |
| `dns-management` | `skills/infrastructure/networking/dns-management/SKILL.md` | devsecops-agent |
| `docker-compose` | `skills/containers/docker-compose/SKILL.md` | devsecops-agent |
| `docker-management` | `skills/containers/docker-management/SKILL.md` | devsecops-agent |
| `dockerfile-hardening` | `skills/dockerfile-hardening/SKILL.md` | devsecops-agent |
| `dockerfile-review` | `skills/docker/dockerfile-review/SKILL.md` | devsecops-agent, typescript-agent |
| `documentation-writer` | `skills/documentation/documentation-writer/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `ebpf-observability` | `skills/observability/ebpf-observability/SKILL.md` | devsecops-agent, observability-sre-agent |
| `electron-ipc-security` | `skills/typescript/electron-ipc-security/SKILL.md` | devsecops-agent, typescript-agent |
| `electron-typescript` | `skills/typescript/electron-typescript/SKILL.md` | typescript-agent |
| `elk-stack` | `skills/observability/elk-stack/SKILL.md` | devsecops-agent, observability-sre-agent |
| `feature-flags` | `skills/release/feature-flags/SKILL.md` | devsecops-agent, typescript-agent |
| `fedramp-compliance` | `skills/fedramp-compliance/SKILL.md` | devsecops-agent |
| `firebase-app-platform` | `skills/infrastructure/platforms/firebase-app-platform/SKILL.md` | devsecops-agent |
| `firewall-config` | `skills/security/network/firewall-config/SKILL.md` | devsecops-agent |
| `gcp-audit-logs` | `skills/gcp-audit-logs/SKILL.md` | devsecops-agent |
| `gcp-cloud-functions` | `skills/infrastructure/cloud-gcp/gcp-cloud-functions/SKILL.md` | devsecops-agent |
| `gcp-cloud-sql` | `skills/infrastructure/cloud-gcp/gcp-cloud-sql/SKILL.md` | devsecops-agent |
| `gcp-compute` | `skills/infrastructure/cloud-gcp/gcp-compute/SKILL.md` | devsecops-agent |
| `gcp-gke` | `skills/infrastructure/cloud-gcp/gcp-gke/SKILL.md` | devsecops-agent |
| `gcp-networking` | `skills/infrastructure/cloud-gcp/gcp-networking/SKILL.md` | devsecops-agent |
| `gcp-secret-manager` | `skills/security/secrets/gcp-secret-manager/SKILL.md` | devsecops-agent |
| `gdpr-compliance` | `skills/gdpr-compliance/SKILL.md` | devsecops-agent |
| `git-workflow` | `skills/release/git-workflow/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `github-actions` | `skills/cicd/github-actions/SKILL.md` | devsecops-agent, typescript-agent |
| `gitlab-ci` | `skills/cicd/gitlab-ci/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `gitlab-migration` | `skills/migrations/gitlab-migration/SKILL.md` | migration-agent |
| `gitlab-pipeline-review` | `skills/cicd/gitlab-pipeline-review/SKILL.md` | devsecops-agent, migration-agent |
| `golden-paths` | `skills/devsecops/golden-paths/SKILL.md` | devsecops-agent |
| `gpu-kubernetes-operations` | `skills/infrastructure/local-ai/gpu-kubernetes-operations/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `gpu-server-management` | `skills/infrastructure/servers/gpu-server-management/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `hashicorp-vault` | `skills/security/secrets/hashicorp-vault/SKILL.md` | devsecops-agent, migration-agent |
| `hashicorp-vault-migration` | `skills/migrations/hashicorp-vault-migration/SKILL.md` | migration-agent |
| `helm-charts` | `skills/orchestration/helm-charts/SKILL.md` | devsecops-agent |
| `hipaa-compliance` | `skills/hipaa-compliance/SKILL.md` | devsecops-agent |
| `identity-access-management` | `skills/infrastructure/it/identity-access-management/SKILL.md` | devsecops-agent |
| `incident-correlation` | `skills/observability/incident-correlation/SKILL.md` | observability-sre-agent |
| `incident-management` | `skills/incident-management/SKILL.md` | devsecops-agent, observability-sre-agent |
| `incident-response` | `skills/security/operations/incident-response/SKILL.md` | devsecops-agent |
| `incident-triage` | `skills/incident-triage/SKILL.md` | devsecops-agent, observability-sre-agent |
| `internal-developer-platform` | `skills/devsecops/internal-developer-platform/SKILL.md` | devsecops-agent |
| `iso27001-compliance` | `skills/iso27001-compliance/SKILL.md` | devsecops-agent |
| `jenkins` | `skills/cicd/jenkins/SKILL.md` | devsecops-agent, migration-agent |
| `jenkins-migration` | `skills/migrations/jenkins-migration/SKILL.md` | migration-agent |
| `jfrog-artifactory-administration` | `skills/migrations/jfrog-artifactory-administration/SKILL.md` | migration-agent |
| `jfrog-artifactory-migration` | `skills/migrations/jfrog-artifactory-migration/SKILL.md` | migration-agent |
| `k8s-manifest-review` | `skills/kubernetes/k8s-manifest-review/SKILL.md` | devsecops-agent |
| `kubernetes-admission-policy` | `skills/devsecops/kubernetes-admission-policy/SKILL.md` | devsecops-agent |
| `kubernetes-hardening` | `skills/security/hardening/kubernetes-hardening/SKILL.md` | devsecops-agent |
| `kubernetes-ops` | `skills/orchestration/kubernetes-ops/SKILL.md` | devsecops-agent |
| `kubernetes-security-audit` | `skills/kubernetes-security-audit/SKILL.md` | devsecops-agent |
| `kustomize` | `skills/orchestration/kustomize/SKILL.md` | devsecops-agent |
| `linux-administration` | `skills/infrastructure/servers/linux-administration/SKILL.md` | devsecops-agent |
| `linux-hardening` | `skills/security/hardening/linux-hardening/SKILL.md` | devsecops-agent |
| `linux-platform-change` | `skills/infrastructure/servers/linux-platform-change/SKILL.md` | devsecops-agent |
| `llm-app-security` | `skills/security/ai/llm-app-security/SKILL.md` | devsecops-agent, typescript-agent, ai-llmops-agent |
| `llm-caching` | `skills/ai/llm-caching/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `llm-cost-optimization` | `skills/ai/llm-cost-optimization/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `llm-fine-tuning` | `skills/infrastructure/local-ai/llm-fine-tuning/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `llm-gateway` | `skills/infrastructure/networking/llm-gateway/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `llm-inference-scaling` | `skills/infrastructure/local-ai/llm-inference-scaling/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `llmops-platform-engineering` | `skills/ai/llmops-platform-engineering/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `load-balancing` | `skills/infrastructure/networking/load-balancing/SKILL.md` | devsecops-agent |
| `local-llm-routing` | `skills/infrastructure/local-ai/local-llm-routing/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `log-pipeline-review` | `skills/log-pipeline-review/SKILL.md` | devsecops-agent, observability-sre-agent |
| `loki-logging` | `skills/observability/loki-logging/SKILL.md` | devsecops-agent, observability-sre-agent |
| `mac-mini-llm-lab` | `skills/infrastructure/local-ai/mac-mini-llm-lab/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `mcp-server-development` | `skills/ai/mcp-server-development/SKILL.md` | ai-llmops-agent |
| `mcp-server-security` | `skills/security/ai/mcp-server-security/SKILL.md` | devsecops-agent, typescript-agent, ai-llmops-agent |
| `mdm-device-management` | `skills/infrastructure/it/mdm-device-management/SKILL.md` | devsecops-agent |
| `migration-readiness-review` | `skills/migrations/migration-readiness-review/SKILL.md` | migration-agent |
| `model-registry-governance` | `skills/ai/model-registry-governance/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `model-serving-kubernetes` | `skills/orchestration/model-serving-kubernetes/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `model-supply-chain-security` | `skills/security/ai/model-supply-chain-security/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `mongodb` | `skills/infrastructure/databases/mongodb/SKILL.md` | devsecops-agent |
| `monitoring-observability-review` | `skills/monitoring-observability-review/SKILL.md` | devsecops-agent, observability-sre-agent |
| `multi-tenant-llm-hosting` | `skills/infrastructure/local-ai/multi-tenant-llm-hosting/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `mysql` | `skills/infrastructure/databases/mysql/SKILL.md` | devsecops-agent |
| `new-relic` | `skills/observability/new-relic/SKILL.md` | devsecops-agent, observability-sre-agent |
| `nexus-migration` | `skills/migrations/nexus-migration/SKILL.md` | migration-agent |
| `nfs-storage` | `skills/infrastructure/storage/nfs-storage/SKILL.md` | devsecops-agent |
| `nodejs-runtime` | `skills/typescript/nodejs-runtime/SKILL.md` | typescript-agent |
| `object-storage` | `skills/infrastructure/storage/object-storage/SKILL.md` | devsecops-agent |
| `ollama-stack` | `skills/infrastructure/local-ai/ollama-stack/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `opa-rego` | `skills/devsecops/opa-rego/SKILL.md` | devsecops-agent |
| `openapi-hardener` | `skills/security/api/openapi-hardener/SKILL.md` | devsecops-agent, typescript-agent |
| `openclaw-deployment-hardening` | `skills/security/hardening/openclaw-deployment-hardening/SKILL.md` | devsecops-agent |
| `openclaw-local-mac-mini` | `skills/infrastructure/local-ai/openclaw-local-mac-mini/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `openclaw-security-hardening` | `skills/infrastructure/local-ai/openclaw-security-hardening/SKILL.md` | devsecops-agent |
| `openshift` | `skills/orchestration/openshift/SKILL.md` | devsecops-agent |
| `opentelemetry` | `skills/observability/opentelemetry/SKILL.md` | devsecops-agent, observability-sre-agent |
| `opentofu-migration` | `skills/infrastructure/iac/opentofu-migration/SKILL.md` | devsecops-agent |
| `osquery-fleet-management` | `skills/devsecops/osquery-fleet-management/SKILL.md` | devsecops-agent |
| `package-management` | `skills/typescript/package-management/SKILL.md` | typescript-agent |
| `pci-dss-compliance` | `skills/pci-dss-compliance/SKILL.md` | devsecops-agent |
| `penetration-testing` | `skills/security/operations/penetration-testing/SKILL.md` | devsecops-agent |
| `performance-tuning` | `skills/infrastructure/servers/performance-tuning/SKILL.md` | devsecops-agent |
| `pipeline-security-review` | `skills/devsecops/pipeline-security-review/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `pipeline-supply-chain-review` | `skills/pipeline-supply-chain-review/SKILL.md` | devsecops-agent, migration-agent |
| `planetscale` | `skills/infrastructure/databases/planetscale/SKILL.md` | devsecops-agent |
| `planning-and-task-breakdown` | `skills/planning/planning-and-task-breakdown/SKILL.md` | devsecops-agent, typescript-agent, migration-agent, observability-sre-agent |
| `platform-engineering` | `skills/platforms/platform-engineering/SKILL.md` | devsecops-agent |
| `podman` | `skills/containers/podman/SKILL.md` | devsecops-agent |
| `policy-as-code` | `skills/policy-as-code/SKILL.md` | devsecops-agent |
| `postgresql` | `skills/infrastructure/databases/postgresql/SKILL.md` | devsecops-agent |
| `pr-risk-summary` | `skills/pr-risk-summary/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `prometheus-grafana` | `skills/observability/prometheus-grafana/SKILL.md` | devsecops-agent, observability-sre-agent |
| `prompt-injection-defense` | `skills/security/ai/prompt-injection-defense/SKILL.md` | devsecops-agent, typescript-agent, ai-llmops-agent |
| `python-async-concurrency` | `skills/python/python-async-concurrency/SKILL.md` | python-agent, migration-agent |
| `python-debugging` | `skills/python/python-debugging/SKILL.md` | python-agent, migration-agent |
| `python-development` | `skills/python/python-development/SKILL.md` | python-agent, migration-agent |
| `python-packaging` | `skills/python/python-packaging/SKILL.md` | python-agent, migration-agent |
| `python-performance` | `skills/python/python-performance/SKILL.md` | python-agent, migration-agent |
| `python-project-configuration` | `skills/python/python-project-configuration/SKILL.md` | python-agent, migration-agent |
| `python-quality-and-testing` | `skills/python-quality-and-testing/SKILL.md` | python-agent, migration-agent |
| `python-refactor` | `skills/python/python-refactor/SKILL.md` | python-agent, migration-agent |
| `python-security-review` | `skills/python-security-review/SKILL.md` | python-agent, migration-agent |
| `python-untrusted-input` | `skills/python/python-untrusted-input/SKILL.md` | python-agent, migration-agent |
| `rag-development` | `skills/ai/rag-development/SKILL.md` | ai-llmops-agent |
| `rag-infrastructure` | `skills/infrastructure/local-ai/rag-infrastructure/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `rag-observability-evals` | `skills/ai/rag-observability-evals/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `readme-generator` | `skills/documentation/readme-generator/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `redis` | `skills/infrastructure/databases/redis/SKILL.md` | devsecops-agent |
| `repo-ai-readiness` | `skills/ai-agents/repo-ai-readiness/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `repo-intelligence` | `skills/repo-intelligence/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `reverse-proxy` | `skills/infrastructure/networking/reverse-proxy/SKILL.md` | devsecops-agent |
| `runbook-creation` | `skills/runbook-creation/SKILL.md` | devsecops-agent, observability-sre-agent |
| `runbook-generator` | `skills/runbook-generator/SKILL.md` | devsecops-agent, observability-sre-agent |
| `saas-security-posture` | `skills/infrastructure/it/saas-security-posture/SKILL.md` | devsecops-agent |
| `sast-scanning` | `skills/security/scanning/sast-scanning/SKILL.md` | devsecops-agent, typescript-agent |
| `sbom-supply-chain` | `skills/security/scanning/sbom-supply-chain/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `secrets-audit` | `skills/security/secrets-audit/SKILL.md` | devsecops-agent, typescript-agent, migration-agent |
| `secrets-rotation` | `skills/devsecops/secrets-rotation/SKILL.md` | devsecops-agent |
| `security-automation` | `skills/security/operations/security-automation/SKILL.md` | devsecops-agent |
| `security-policy-testing` | `skills/devsecops/security-policy-testing/SKILL.md` | devsecops-agent |
| `self-service-provisioning` | `skills/devsecops/self-service-provisioning/SKILL.md` | devsecops-agent |
| `semantic-versioning` | `skills/release/semantic-versioning/SKILL.md` | devsecops-agent, typescript-agent |
| `service-mesh` | `skills/infrastructure/networking/service-mesh/SKILL.md` | devsecops-agent |
| `sli-slo-error-budgets` | `skills/observability/sli-slo-error-budgets/SKILL.md` | observability-sre-agent |
| `soc2-compliance` | `skills/soc2-compliance/SKILL.md` | devsecops-agent |
| `sops-encryption` | `skills/security/secrets/sops-encryption/SKILL.md` | devsecops-agent, migration-agent |
| `sre-dashboards` | `skills/observability/sre-dashboards/SKILL.md` | devsecops-agent, observability-sre-agent |
| `ssh-configuration` | `skills/infrastructure/servers/ssh-configuration/SKILL.md` | devsecops-agent |
| `ssl-tls-management` | `skills/security/network/ssl-tls-management/SKILL.md` | devsecops-agent |
| `startup-it-troubleshooting` | `skills/infrastructure/it/startup-it-troubleshooting/SKILL.md` | devsecops-agent |
| `supply-chain-attack-response` | `skills/security/scanning/supply-chain-attack-response/SKILL.md` | devsecops-agent |
| `supply-chain-provenance` | `skills/devsecops/supply-chain-provenance/SKILL.md` | devsecops-agent |
| `synthetic-monitoring` | `skills/observability/synthetic-monitoring/SKILL.md` | observability-sre-agent |
| `systematic-debugging` | `skills/quality/systematic-debugging/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, observability-sre-agent |
| `systemd-services` | `skills/infrastructure/servers/systemd-services/SKILL.md` | devsecops-agent |
| `tailscale-management` | `skills/devsecops/tailscale-management/SKILL.md` | devsecops-agent |
| `technical-debt-analysis` | `skills/shared/technical-debt-analysis/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `terraform-aws` | `skills/infrastructure/cloud-aws/terraform-aws/SKILL.md` | devsecops-agent |
| `terraform-azure` | `skills/infrastructure/cloud-azure/terraform-azure/SKILL.md` | devsecops-agent |
| `terraform-drift-detection` | `skills/devsecops/terraform-drift-detection/SKILL.md` | devsecops-agent |
| `terraform-gcp` | `skills/infrastructure/cloud-gcp/terraform-gcp/SKILL.md` | devsecops-agent |
| `terraform-plan-analysis` | `skills/terraform/terraform-plan-analysis/SKILL.md` | devsecops-agent |
| `terraform-review` | `skills/terraform/terraform-review/SKILL.md` | devsecops-agent |
| `terraform-security-review` | `skills/terraform-security-review/SKILL.md` | devsecops-agent |
| `terraform-state-management` | `skills/devsecops/terraform-state-management/SKILL.md` | devsecops-agent |
| `terraform-testing` | `skills/devsecops/terraform-testing/SKILL.md` | devsecops-agent |
| `threat-model` | `skills/security/threat-model/SKILL.md` | devsecops-agent |
| `threat-modeling` | `skills/security/operations/threat-modeling/SKILL.md` | devsecops-agent, typescript-agent |
| `typescript-api-development` | `skills/typescript/typescript-api-development/SKILL.md` | typescript-agent |
| `typescript-async-concurrency` | `skills/typescript/typescript-async-concurrency/SKILL.md` | typescript-agent |
| `typescript-build-tooling` | `skills/typescript/typescript-build-tooling/SKILL.md` | typescript-agent |
| `typescript-debugging` | `skills/typescript/typescript-debugging/SKILL.md` | typescript-agent |
| `typescript-development` | `skills/typescript/typescript-development/SKILL.md` | typescript-agent |
| `typescript-migration` | `skills/typescript/typescript-migration/SKILL.md` | typescript-agent |
| `typescript-performance` | `skills/typescript/typescript-performance/SKILL.md` | typescript-agent |
| `typescript-project-configuration` | `skills/typescript/typescript-project-configuration/SKILL.md` | typescript-agent |
| `typescript-refactor` | `skills/typescript/typescript-refactor/SKILL.md` | typescript-agent |
| `typescript-review` | `skills/typescript/typescript-review/SKILL.md` | devsecops-agent, typescript-agent |
| `typescript-security-review` | `skills/typescript/typescript-security-review/SKILL.md` | typescript-agent |
| `typescript-testing` | `skills/typescript/typescript-testing/SKILL.md` | typescript-agent |
| `typescript-untrusted-input` | `skills/typescript/typescript-untrusted-input/SKILL.md` | typescript-agent |
| `understand` | `skills/understand/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-chat` | `skills/understand-chat/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-dashboard` | `skills/understand-dashboard/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-diff` | `skills/understand-diff/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-domain` | `skills/understand-domain/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-explain` | `skills/understand-explain/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-figma` | `skills/understand-figma/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-knowledge` | `skills/understand-knowledge/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `understand-onboard` | `skills/understand-onboard/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, ai-llmops-agent, observability-sre-agent |
| `user-management` | `skills/infrastructure/servers/user-management/SKILL.md` | devsecops-agent |
| `vector-database-ops` | `skills/infrastructure/databases/vector-database-ops/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `vendor-management` | `skills/vendor-management/SKILL.md` | devsecops-agent |
| `vercel-deployments` | `skills/infrastructure/platforms/vercel-deployments/SKILL.md` | devsecops-agent |
| `verification-before-completion` | `skills/quality/verification-before-completion/SKILL.md` | devsecops-agent, python-agent, typescript-agent, migration-agent, observability-sre-agent |
| `vllm-server` | `skills/infrastructure/local-ai/vllm-server/SKILL.md` | devsecops-agent, ai-llmops-agent |
| `vpn-setup` | `skills/security/network/vpn-setup/SKILL.md` | devsecops-agent |
| `vscode-extension-development` | `skills/typescript/vscode-extension-development/SKILL.md` | typescript-agent |
| `vulnerability-scanning` | `skills/security/scanning/vulnerability-scanning/SKILL.md` | devsecops-agent |
| `waf-setup` | `skills/security/network/waf-setup/SKILL.md` | devsecops-agent |
| `windows-hardening` | `skills/security/hardening/windows-hardening/SKILL.md` | devsecops-agent |
| `windows-server` | `skills/infrastructure/servers/windows-server/SKILL.md` | devsecops-agent |
| `zero-trust` | `skills/security/network/zero-trust/SKILL.md` | devsecops-agent |
