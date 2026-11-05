# Python Repo Agent Guide

## Purpose

Operate safely on Python code with emphasis on input safety, dependency hygiene, logging, testing, and minimal patches.

## Tech Stack

- Python applications, scripts, Lambdas, and tooling

## Validation Commands

- `ruff check .`
- `pytest -q`
- `bandit -r .`

## Security Rules

- avoid unsafe subprocess, eval, and deserialization
- enforce timeouts on network calls
- do not log secrets or sensitive payloads

## Rollback Policy

- prefer single-file or single-function rollback when possible
- note data handling impact before changing scripts that mutate systems

## Repo-Specific Notes

- Add runtime, packaging, and environment notes here.

## Exceptions

- Document approved deviations and expiry dates here.
