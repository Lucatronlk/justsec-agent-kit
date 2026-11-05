# Threat Modeling Instructions

> Adapted from `awesome-copilot/skills/threat-model-analyst/SKILL.md` (STRIDE+Abuse methodology, 8 reference files in source repo) and `skills/data-breach-blast-radius`. Converted to generic Markdown.

## When To Use

- New system/service design before build.
- Significant architecture change (new trust boundary, new data flow, new external integration).
- Explicit user request for a threat model. Do not run this unprompted on every review — it's a deliberate, heavier-weight activity.

## Methodology: STRIDE + Abuse

| Category | Question |
|---|---|
| **S**poofing | Can an actor impersonate another user/service? |
| **T**ampering | Can data/code be modified in transit or at rest without detection? |
| **R**epudiation | Can an actor deny having performed an action (no audit trail)? |
| **I**nformation Disclosure | Can sensitive data leak to an unauthorized party? |
| **D**enial of Service | Can an actor degrade or block availability? |
| **E**levation of Privilege | Can an actor gain higher privilege than granted? |
| **A**buse Cases | Can legitimate functionality be abused for a malicious purpose (e.g., mass account creation, resource exhaustion)? |

## Process

1. **Scope the system**: draw trust boundaries (data-flow diagram: external actors, processes, data stores, trust boundary lines).
2. **Enumerate assets**: what data/functionality is worth attacking (PII, credentials, payment data, admin functions)?
3. **Apply STRIDE-A per element**: for every process, data store, and data flow crossing a trust boundary, ask all 6+1 questions.
4. **Rate each threat**: likelihood × impact → severity.
5. **Mitigate or accept**: for each threat, assign a mitigation (control) or an explicit accepted-risk decision with an owner.
6. **Re-run incrementally**: on subsequent changes, diff the new design against the last baseline model rather than redoing the full analysis from scratch.

## Blast-Radius / Data-Breach Angle (adapted from `data-breach-blast-radius`)

For data-sensitive systems, also quantify pre-breach impact:

- Inventory PII/PHI/PCI data classes touched.
- Trace data flow end-to-end (ingestion → storage → processing → egress).
- Score exposure vectors (public endpoint, third-party integration, insider access).
- Note applicable compliance exposure (GDPR, CCPA, HIPAA) — cite only law-exact figures you can verify; label estimates as heuristic.

## Output Format

```markdown
## Threat Model: <system name>

### Scope & Trust Boundaries
<diagram description or mermaid diagram>

### Assets
- ...

### Threats (STRIDE-A)
| ID | Element | Category | Threat | Likelihood | Impact | Severity | Mitigation | Status |
|----|---------|----------|--------|-----------|--------|----------|-----------|--------|

### Residual Risk
<explicit list of accepted risks with owner>
```

## Safety Notes

- Only activate on explicit request or clear architecture-change trigger — avoid over-triggering on routine PRs.
- Do not fabricate compliance fine figures; clearly separate cited law from heuristic estimate.
