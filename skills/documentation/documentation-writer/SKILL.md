---
name: documentation-writer
description: Writes or reviews Diátaxis documentation when a tutorial, how-to, reference, explanation, or architecture document is requested.
---

# documentation-writer

## Purpose
Write or review project documentation (tutorials, how-to guides, reference, or explanation docs) using the Diátaxis framework, grounded in the actual project.

## When To Use
- A new document is requested (tutorial, how-to, reference, or explanation).
- Existing documentation needs review for clarity, accuracy, or structure.
- Architecture documentation is needed (use the C4 model breakdown).

## Inputs Expected
- The documentation request or existing doc to review.
- Access to the relevant source/config to verify accuracy.
- Optional: existing docs to match tone/terminology (context only, not to copy from).

## Step-By-Step Process
1. Determine the Diátaxis type (tutorial/how-to/reference/explanation), target audience, the reader's goal, and explicit scope — ask if any of these are unclear.
2. Propose a structure/outline and get it confirmed before writing full content (skip for trivial edits).
3. Draft content in Markdown, verifying every code snippet/command/config value against the actual project — never fabricate.
4. For architecture docs, structure by C4 level (Context/Container/Component/Infrastructure) as appropriate to the audience.
5. Review for the guiding principles: clarity, active voice, progressive disclosure, one idea per paragraph, concrete examples.

## Validation Checklist
- [ ] Diátaxis type identified and consistently maintained (not mixing tutorial/reference/explanation in one document)
- [ ] Every code snippet/command verified against actual source, not memory
- [ ] Audience and their goal explicitly addressed
- [ ] Structure confirmed before full content was written (for non-trivial docs)
- [ ] No content copied verbatim from unrelated external docs
- [ ] Terminology consistent with the rest of the project's documentation

## Output Format
- The requested document in Markdown.
- A short summary noting: Diátaxis type, audience, scope, and any assumptions made.

## Safety Notes
- Read-only with respect to application/production code — this skill produces documentation, it does not modify application logic.
- Never fabricate a command, API signature, or config value; if unverifiable, say so explicitly rather than guessing.

Related instructions: `instructions/documentation/technical-writing.instructions.md`
