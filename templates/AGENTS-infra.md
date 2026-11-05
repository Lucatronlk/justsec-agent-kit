# Infrastructure Repo Agent Guide

## Purpose

Operate safely on infrastructure-as-code repositories with emphasis on IAM, network exposure, encryption, logging, and rollback.

## Tech Stack

- Terraform and cloud provider configuration
- Optional CI/CD and container build logic

## Validation Commands

- `terraform fmt -check -recursive`
- `terraform validate`
- `tflint` if available
- `tfsec` or `checkov` if available

## Security Rules

- no secrets in code or tfvars
- least privilege only
- explicit public exposure review required
- encryption and audit logging required

## Rollback Policy

- revert the smallest affected module or variable change
- state impact must be understood before apply or rollback

## Repo-Specific Notes

- Add module paths, environment directories, and owner details here.

## Exceptions

- Document approved deviations and expiry dates here.
