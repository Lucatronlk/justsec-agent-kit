# Monitoring Repo Agent Guide

## Purpose

Operate safely on monitoring and log pipeline repositories with focus on signal quality, secure transport, retention, and alert usefulness.

## Tech Stack

- Prometheus, Grafana, Loki, Promtail, Alloy, Vector, Logstash, Splunk

## Validation Commands

- `promtool check config <file>`
- `promtool check rules <file>`
- `docker compose config`

## Security Rules

- treat logs as sensitive
- protect metrics and dashboard endpoints
- review label cardinality and alert routing changes

## Rollback Policy

- rollback by pipeline or ruleset, not by broad stack rewrite
- preserve evidence paths during incident work

## Repo-Specific Notes

- Add observability stack details and critical alerts here.

## Exceptions

- Document approved deviations and expiry dates here.
