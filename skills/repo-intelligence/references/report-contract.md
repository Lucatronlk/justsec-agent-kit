# Repository intelligence YAML contract (workflow version 1)

Use this shape with real values. Empty collections mean no entries established, not that the feature is impossible. Explain omissions in coverage. `capabilities` buckets hold capability records; the `implicit` bucket contains only IDs referencing those records. Other capability indexes also use IDs to avoid conflicting duplicates.

```yaml
schema_version: 1
workflow_version: 1
repository:
  name: example
  path: /absolute/repository
  git_commit: null
  analyzed_at: '2026-01-01T00:00:00Z'
  dirty: false
analysis:
  status: partial # complete | partial
  coverage:
    inspected: []
    not_inspected: []
    notes: []
  understand_anything:
    status: unavailable # current | updated | unavailable | failed | stale
    invocation: null
    mode: null # full | incremental | reused | null
    artifact_path: null
    git_commit: null
    notes: []
  validation:
    yaml_parsed: false
    evidence_checked: false
    notes: []
documented_purpose:
  summary: null
  evidence: []
architecture:
  languages: []
  frameworks: []
  entrypoints: []
  apis: []
  cli: []
  storage: []
  messaging: []
  external_dependencies: []
  deployment_models: []
capabilities:
  native: []
  undocumented: []
  implicit: []
  repurposable: []
  minor_modification: []
  major_modification: []
  incompatible: []
security_capabilities: []
integration_surfaces: []
extension_points: []
reusable_components: []
possible_extractions: []
possible_wrappers: []
architectural_limitations: []
external_dependencies: []
reuse_strategies: []
evidence_summary: []
confidence:
  overall: low # high | medium | low
  notes: []
```

Each capability record requires `id`, `name`, `summary`, `classification`, `basis`, `confidence`, `evidence`, `prerequisites`, `limitations`, `modifications`, `reuse_strategy`, and `validation`. `classification` must match its bucket. `basis` is `SUPPORTED_BY_CODE` or `INFERRED_FROM_ARCHITECTURE`. `confidence` is high/medium/low. `reuse_strategy` is one of the eight strategies in SKILL.md. `modifications` is a list of objects containing `path`, `symbol`, `change`, and `verification`; use an empty list for no source changes. `validation` distinguishes tests inspected, tests run with actual results, and proposed tests.

An evidence item requires `path` (relative to the selected repo), `line_start`, `line_end`, `symbol` (nullable), `kind` (implementation/configuration/test/documentation), and `explanation`. Lines are positive integers within a file that was inspected. No secret excerpts. Evidence must support the attached claim; imports alone do not prove a feature is used.

Architecture list entries and all substantive component, surface, extension, extraction, wrapper, limitation and dependency records require a `name`, `summary`, `evidence`, and `confidence`, plus useful type-specific detail. Add `reuse_strategy` to reusable components. `security_capabilities` contains capability IDs. `reuse_strategies` contains `subject_id`, `strategy`, `rationale`, `prerequisites`, `limitations`, and `evidence`. `evidence_summary` lists key supporting files and explanations, not substitutes for per-claim evidence.

Complete requires successful/current Understand Anything, finished stated coverage, YAML parse validation, evidence checks, stable checkout and no unresolved validation errors. Partial reports are valid deliverables but cannot be reused as completed analyses. A dirty checkout may receive a complete snapshot analysis if stable during the run, but is never reusable. Never claim exhaustive coverage when sampling.
