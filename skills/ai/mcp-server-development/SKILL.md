---
name: mcp-server-development
description: Build MCP servers with typed tools, resource schemas, authorization boundaries, and reliable transport behavior.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# MCP Server Development

## Inputs
MCP client capabilities, proposed tools/resources/prompts, transport, identity model, backend APIs, and trust boundaries.

## Workflow
1. Define narrow tool contracts, schemas, side-effect levels, and per-client authorization.
2. Implement validation, timeouts, pagination, structured errors, and redaction; separate untrusted resource text from instructions.
3. Test handshake, capability negotiation, tool discovery, invalid args, cancellation, and concurrent calls.
4. Document tool permissions and deployment health checks before staged rollout.

## Validation
Run protocol conformance and denied/allowed integration cases against a nonproduction backend; verify no secret content in logs.

## Rollback and safety
Default tools to read-only; require explicit approval for writes. Disable affected tool/server version and restore previous release if unauthorized access or errors occur; never expose backend tokens to clients.
