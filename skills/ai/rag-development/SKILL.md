---
name: rag-development
description: Develop RAG retrieval pipelines with provenance, access filtering, chunking, and grounded answer evaluation.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# RAG Development

## Inputs
Corpus inventory, document ACLs, freshness targets, chunking constraints, embedding model, queries, and evaluation set.

## Workflow
1. Define ingestion consent, tenant/ACL boundaries, metadata, deduplication, and deletion propagation.
2. Prototype parsing/chunking, embedding, hybrid retrieval, reranking, and citations with versioned indexes.
3. Evaluate recall@k, answer groundedness, stale content, and adversarial text as untrusted data.
4. Stage indexing updates with shadow traffic and monitor retrieval latency and access-filter misses.

## Validation
Test cross-tenant denied retrieval, source citation accuracy, document updates/deletes, and representative no-answer queries.

## Rollback and safety
Do not ingest restricted documents or read secrets without approval. Retain previous index alias and revert on quality/security regression; remove contaminated chunks and reindex before resuming traffic.
