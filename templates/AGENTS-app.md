# Application Repo Agent Guide

## Purpose

Operate safely on application repositories with focus on minimal patches, dependency hygiene, CI safety, and observability.

## Tech Stack

- application code and supporting build or deploy files

## Validation Commands

- run the repo's native tests and linters
- validate CI changes with `actionlint` or equivalent when present

## Security Rules

- no secrets in code
- review auth, input handling, logging, and dependency pinning
- protect production release paths

## Rollback Policy

- keep changes small enough for targeted revert
- preserve compatibility unless explicitly changed

## Repo-Specific Notes

- Add app entry points, environments, and owner details here.

## Exceptions

- Document approved deviations and expiry dates here.
