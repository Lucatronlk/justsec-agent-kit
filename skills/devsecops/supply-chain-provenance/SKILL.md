---
name: supply-chain-provenance
description: Define signed build provenance and artifact verification gates from source commit to deployment.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Supply Chain Provenance

## Inputs
Build pipeline, source trust model, artifact registry, signing identity, SBOM format, and deploy policy.

## Workflow
1. Map source, builder, dependencies, release attestations, and trust boundaries.
2. Produce immutable digests, SBOMs, and provenance linking commit, builder identity, workflow, and artifact.
3. Specify signature verification, expected issuer/subject, digest pinning, and promotion checks.
4. Test tampered, missing, and mismatched attestations before gating releases.

## Validation
Verify a real signed canary and reject unsigned or wrong-source artifacts; record reproducibility limits.

## Rollback and safety
No release policy enforcement without approval. Retain previous trusted release digest and deploy path for rollback; protect signing keys and never log tokens or private key material.
