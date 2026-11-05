# Repo Classification Rules

Repositories may have more than one classification.

## Terraform

Classify as Terraform when the repo contains `*.tf` files or `.terraform.lock.hcl`.

## Kubernetes

Classify as Kubernetes when the repo contains any of:

- `Chart.yaml`
- `values.yaml`
- Kubernetes manifests under directories such as `kubernetes`, `k8s`, `manifests`, `charts`, or `helm`

## Python

Classify as Python when the repo contains any of:

- `pyproject.toml`
- `requirements.txt`
- `*.py`

## Monitoring

Classify as Monitoring when the repo contains configs or pipelines for:

- Prometheus
- Vector
- Alloy
- Logstash
- Splunk
- Loki
- Promtail
- alerting or centralized logging stacks

## Application

Use Application as the fallback classification when no stronger type is detected.

## Mixed Repositories

- Keep all detected classes.
- Prioritize validation commands by changed area.
- Use combined AGENTS guidance instead of forcing a single template.
