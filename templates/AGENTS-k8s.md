# Kubernetes Repo Agent Guide

## Purpose

Operate safely on Kubernetes manifests and Helm charts with focus on RBAC, network exposure, pod security, and release safety.

## Tech Stack

- Kubernetes manifests
- Helm charts and values

## Validation Commands

- `helm lint <chart>`
- `kubectl apply --dry-run=client -f <path>`
- `kubeconform` if available

## Security Rules

- avoid privileged pods and broad RBAC
- review ingress, service type, and network policy
- no secrets in manifests unless encrypted by approved workflow

## Rollback Policy

- prefer chart or manifest rollback at the smallest release boundary
- state blast radius before changing shared charts

## Repo-Specific Notes

- Add namespaces, release names, and cluster assumptions here.

## Exceptions

- Document approved deviations and expiry dates here.
