---
name: local-llm-routing
description: Measured knowledge for sending work to a local Ollama server and for configuring one. Send exactly the num_ctx a model is loaded with, think=false for cheap text tasks, code does counting/grouping and the model writes prose only, keep an evaluation record per model artifact, and verify reachability before promising a model to an agent. Single GPU and small context first; every setting configurable. Use when routing text work to a local model, writing an Ollama client, or sizing models and context.
---

# local-llm-routing

## Purpose
Route text work to a local Ollama model **safely and measurably**. A local model costs no credits but is slow and loose: use it for text-in / text-out drafts that a stronger model or a human then checks. Anything that changes state, carries security risk, or must be exactly right stays with code or a stronger model.

## When To Use
- Routing text work (triage, summaries, drafts) to a local model.
- Writing a client that calls Ollama, or sizing models/context on a GPU box.
- Deciding whether a given local model may be assigned a task class.
- **Not for** cloud-model prompting.

## Inputs Expected
- `OLLAMA_HOST` / endpoint from your own config (examples use the default `http://localhost:11434`).
- The exact model artifact (tag **and digest**, not the family name) and its quantisation.
- The loaded `num_ctx`, and the hardware class (accelerator type + VRAM class only — no hostnames).

## Step-By-Step Process

### 1. Division of labour — the rule that matters most
- **Code does the grouping, counting, sorting, deduplication, and every statistic.** The model never produces a number, a count, or a category assignment that anything depends on.
- **The model writes prose only**, from facts code already computed and passed in. Someone then verifies each claim in the prose against the source.
- Never let it write rules, code, or security judgments.
- Classification with free-text labels is unreliable (a small model's role labels were ~85% right, domain labels ~46%). Give it a **closed list** of allowed labels and validate its output against the list **in code**.

### 2. Calling Ollama
1. **Send exactly the `num_ctx` the model is already loaded with.** A different value reloads the model and can evict a neighbour sharing the GPU (measured twice; in one case a second model's larger default context evicted the first even though its `keep_alive` was `-1`, so **`keep_alive` does not protect a resident model from a context change**). Find the loaded value with `ollama ps` or `GET /api/ps` and confirm it in the runner log.
2. **`think: false` for cheap tasks.** A thinking model spends hundreds of tokens before a one-sentence answer (436 evaluation tokens for one sentence on a 12B-class model; ~15× fewer with thinking off on a 4B-class model). Opt in to thinking only when the task needs reasoning.
3. **Structured output.** Native `format` accepts a JSON schema; still validate the result in code, and ground the schema in the prompt. Schema-valid is not correct.
4. **Role aliases / Modelfiles.** Whether a `FROM` alias shares a loaded runner with its base model is UNVERIFIED — until you test it, send the role as the request `system` message to the resident base model.
5. **Models that cannot co-reside evict each other**; check VRAM fit before adding a model to a shared box. Measured (Ollama 0.33.2): a 12B-class model and a second model fit together at context 8192 but **not** 16384.
6. **Configurable, not hard-coded.** Take host, model, context and timeouts from environment/config with a single-instance default.

### 3. Reachability and dispatch
- **Probe before assuming.** Check the server answers before promising it to an agent. A recorded probe result is stale after a few hours — say how old it is. If unreachable, write `local model: n/a - <reason>` and use another route; do not hang on a timeout.
- **Naming the local step in a task does not make the agent use it** (only ~5 of 14 briefs produced a logged call). Inspecting the brief proves only that it was named — verify use from the tool's own call log, not the report.
- Subagents without network access to the server cannot call it.

### 4. Evaluation record (before assigning a task class)
Record, and re-measure when any field changes: exact artifact (tag + digest), quantisation, loaded `num_ctx` + model max, runtime version (e.g. Ollama release), licence, hardware class, and a **measured** result per task class (pass/fail against a stated check, number of runs, sanitised inputs). "Seemed fine" is not a result. A family name proves nothing about tool support, accuracy, or context.

## Known Failure Modes (measured)
- Misspelled repository names; the same CVE given different priorities on different runs; ungrounded "false positive" verdicts; dropped headline items.
- Latency ~55–215 s for a long draft — run in the background or raise the client timeout.
- Multi-GPU NVIDIA trap (Ollama 0.33.2): Ollama also enumerated devices through Vulkan, which ignores `CUDA_VISIBLE_DEVICES`, so a per-device split placed models on the wrong devices. Setting `OLLAMA_VULKAN=0` in each service unit fixed it. Verify placement from the service log (`journalctl -u <ollama-unit> | grep "using device"`), then confirm each model shows 100% on GPU in `ollama ps` after warm-up.

## Validation Checklist
- [ ] Client sends the same `num_ctx` the model is loaded with (`ollama ps` `context_length` == client `num_ctx`)
- [ ] `think: false` unless reasoning is required
- [ ] Schema output validated in code, not trusted from the model
- [ ] Counts/groupings/statistics computed in code, never by the model
- [ ] Names/identifiers/claims in the draft diffed against the source before keeping a sentence
- [ ] Reachability probed, with the age of the result stated
- [ ] An evaluation record exists for the exact artifact
- [ ] Host/model/context/timeout are configurable (no baked-in personal layout)

## Output Format
The agent's standard report header, then:
- Summary: the routing decision (model artifact, context, task class) and why.
- Findings by severity: mismatch/eviction/placement risks.
- Evidence: `ollama ps`/`api/ps` output, `load_duration` comparison, placement log lines (redacted).
- Fix: config or client change.
- Validation: the commands that confirm context match, placement, and non-reload.
- Rollback: revert guidance.
- Residual risk: unverified model behaviours (aliases, tool support).

## Safety Notes
- Never expose a hostname, address, or device layout in output — hardware class only.
- A local model never writes code, rules, or verdicts; verify every claim it drafts.
- Keep every setting configurable; never bake one machine's layout into a skill.

Related instructions: `instructions/ai-agents/context-engineering.instructions.md`, `instructions/devsecops/devsecops-general.instructions.md`
Related skills: `skills/infrastructure/local-ai/ollama-stack/SKILL.md`, `skills/infrastructure/local-ai/vllm-server/SKILL.md`, `skills/infrastructure/local-ai/gpu-kubernetes-operations/SKILL.md`, `skills/ai/llm-cost-optimization/SKILL.md`

Attribution: adapted from `ChiefGyk3D/department-of-internal-arguments` pack `local-llm-routing` (MIT, © 2026 ChiefGyk3D).
