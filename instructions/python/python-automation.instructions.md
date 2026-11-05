# Python Automation Instructions

> Synthesized from `awesome-copilot` (`skills/aws-cdk-python-setup`, `skills/agent-governance` Python patterns) and `awesome-opencode` (`data/agents/python-agent.yaml`, `data/projects/opentab.yaml` stdlib-only pattern, `data/projects/eval-harness.yaml`). Converted to generic Markdown.

## When To Use

Writing Python automation scripts, CLIs, infra tooling, or agent helper scripts.

## Environment & Dependencies

- Use a virtual environment (`venv`) or a modern manager (`uv`, `poetry`) — never install packages into a system/global interpreter for project work.
- Prefer the standard library when it's sufficient (see `opentab` pattern: a fully-featured local CLI tool built with zero external dependencies) — fewer dependencies means smaller supply-chain surface.
- Pin dependency versions in `requirements.txt`/`pyproject.toml` (`==` or tight `~=` ranges) for anything deployed; use lockfiles (`uv.lock`, `poetry.lock`) where available.

## Code Quality Baseline

- Type hints on public functions; run `mypy` or `pyright` in CI where feasible.
- Format with `black` (or `ruff format`); lint with `ruff` (covers flake8+isort+more in one tool).
- Structure CLIs with `argparse`/`click`/`typer`; avoid ad hoc `sys.argv` parsing for anything beyond a one-off script.
- Use `logging` module, not `print()`, for anything that runs unattended (cron, CI, agent-invoked scripts).

## Safe Automation Patterns

- Any script that calls cloud APIs, shells out, or touches the filesystem broadly should support a `--dry-run` flag.
- Use `subprocess.run([...], check=True, timeout=...)` — never `shell=True` with unsanitized input (command injection).
- Requests to external services must set explicit timeouts (`requests.get(url, timeout=10)`); a hung request should not hang the agent indefinitely.
- Validate/parse untrusted input (API responses, file contents) before acting on it — never `eval()`/`pickle.loads()` on untrusted data.

## Testing

- `pytest` as the default test runner; separate unit tests from integration tests that require live credentials.
- CI-safe pattern: default test run should not require cloud credentials or network access; gate integration tests behind an explicit opt-in env var.
- For agent-driven regression testing of automation scripts themselves, a lightweight harness (bash + `jq` + `python3` stdlib, git pre-push hook + CI composite action, with a hard cost/time ceiling) is a good low-dependency pattern to replicate for validating agent-authored changes before merge.

## Packaging

- Use `pyproject.toml` (PEP 621) over legacy `setup.py` for new projects.
- If distributing a CLI, prefer `pipx`-installable packaging (isolated environment per tool).

## Safety Notes

- Never embed cloud credentials or API keys directly in scripts — read from environment variables or a secret manager at runtime.
- Never auto-run destructive operations (`rm -rf`, mass resource deletion) without a `--dry-run` preview and explicit confirmation flag.
