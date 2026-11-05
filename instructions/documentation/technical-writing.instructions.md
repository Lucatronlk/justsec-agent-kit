# Technical Writing / Documentation Instructions

> Adapted from `awesome-copilot` (`skills/documentation-writer` — Diátaxis framework, `agents/project-documenter.agent.md` — C4 model + auto-discovery, `skills/create-readme`). Converted to generic Markdown; MS Word/draw.io-specific output pipeline from `project-documenter` omitted (Markdown-first here), core writing framework retained.

## When To Use

Writing or reviewing any project documentation: README, architecture docs, runbooks, API reference, how-to guides, onboarding docs.

## The Diátaxis Framework (https://diataxis.fr/)

Documentation serves one of four distinct purposes — know which one you're writing before you start:

| Type | Orientation | Purpose | Analogy |
|---|---|---|---|
| **Tutorial** | Learning | Guide a newcomer through a successful first outcome, step by step | A lesson |
| **How-to guide** | Problem-solving | Steps to solve one specific, real problem | A recipe |
| **Reference** | Information | Accurate, complete technical description (APIs, config options, CLI flags) | A dictionary |
| **Explanation** | Understanding | Discuss the *why* behind a design/architecture decision | A discussion |

Don't mix types in one document — a README that tries to be a tutorial, reference, and explanation simultaneously usually serves none of them well. Split into linked documents when a project grows past "quick start."

## Guiding Principles

- **Clarity**: simple, unambiguous language; define technical terms on first use.
- **Accuracy**: code snippets and technical details must be correct and current — verify against actual source/config, don't guess.
- **User-centricity**: every document serves a specific reader's specific goal — identify the audience before writing.
- **Consistency**: consistent tone, terminology, and formatting across a project's docs.
- **Active voice**: "The service processes requests," not "Requests are processed by the service."
- **Progressive disclosure**: overview first, details on demand — don't front-load a README with implementation minutiae.
- **One idea per paragraph**: keep paragraphs scannable.
- **Concrete over abstract**: use real file paths, class names, and command output from the actual project, not generic placeholders.

## Workflow For Any Documentation Request

1. **Clarify before writing**: document type (tutorial/how-to/reference/explanation), target audience, the reader's goal, and explicit scope (what's included/excluded).
2. **Propose a structure** (outline/table of contents) and get it confirmed before writing full content, for anything beyond a trivial doc.
3. **Generate content** in well-formatted Markdown, grounded in the actual codebase/config — don't copy from unrelated example docs verbatim, use them only for tone/structure inspiration if provided.
4. **Verify accuracy**: cross-check code snippets/commands actually work against the current source, not from memory of an earlier version.

## Architecture Documentation (C4 Model)

For system/architecture docs, structure by C4 abstraction level so readers can choose their zoom level:

| Level | Scope |
|---|---|
| Context | The system in its environment — external actors and systems |
| Container | Internal deployable units and how they communicate |
| Component | Class/module-level relationships within a container |
| Infrastructure | Deployment/runtime topology |

## README Conventions

- Keep it concise; don't over-use emojis.
- Don't duplicate content that belongs in dedicated files (`LICENSE`, `CONTRIBUTING.md`, `CHANGELOG.md`) — link to them instead.
- Use GitHub-Flavored Markdown, including GitHub admonition syntax (`> [!NOTE]`, `> [!WARNING]`) where it clarifies something important.
- Cover: what it is, quick start (fewest steps to a working example), configuration, and where to go for deeper docs — not exhaustive API reference inline.

## Safety Notes

- Never fabricate a code example, command, or config value — verify against the actual project before including it.
- Never copy content from external example READMEs/docs verbatim into a project's own documentation; use them only as structural/tone inspiration if the user explicitly points to them.
- Treat any documentation-generation agent as read-only with respect to production code — it should produce docs, not modify application logic.
