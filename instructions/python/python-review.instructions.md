# Python Review Instructions

> Synthesized from `awesome-copilot` (`agents/sast-sca-security-analyzer.agent.md` Python-specific patterns, `instructions/security-and-owasp.instructions.md`). Converted to generic Markdown.

## When To Use

Reviewing Python code for correctness, security, and maintainability.

## Security Review Checklist (Python-specific)

- **Deserialization**: `pickle.loads()`/`yaml.load()` (without `SafeLoader`)/`eval()`/`exec()` on untrusted input — flag as Critical.
- **Subprocess**: `subprocess.run(..., shell=True)` with any user-influenced string — command injection risk; prefer list-form args with `shell=False`.
- **SQL**: string-formatted queries (`f"SELECT * FROM x WHERE id={id}"`) — require parameterized queries (`cursor.execute(query, (id,))`).
- **Requests**: missing `timeout=` on `requests`/`httpx` calls — can hang indefinitely; missing `verify=True` (TLS verification disabled) — flag as High.
- **Secrets**: hardcoded API keys/passwords, `os.environ.get("SECRET", "default-value")` with a real-looking default.
- **Path handling**: unsanitized path joins from user input (`os.path.join(base, user_input)` without validating no `..` traversal).
- **Dependency hygiene**: unpinned or known-vulnerable packages in `requirements.txt` — cross-check against advisory databases where tooling is available.

## Code Quality Checklist

- Type hints present and consistent; no bare `except:` (must catch specific exceptions).
- No mutable default arguments (`def f(x=[])`).
- Context managers (`with open(...) as f`) for file/resource handling instead of manual close.
- Functions have a single clear responsibility; avoid deeply nested conditionals (prefer early returns).
- Docstrings on public modules/classes/functions describing purpose, args, returns.

## Validation Commands

```bash
ruff check .
mypy . || pyright
pytest
pip-audit  # or: safety check
```

## Output Format

- Summary
- Findings by severity (cite file:line)
- Evidence
- Fix (smallest safe patch, e.g. before/after snippet)
- Validation
- Residual risk

## Safety Notes

- Never auto-run `pip install`/`pip-audit --fix`-style auto-remediation without review — present findings and let a human apply fixes.
- Treat any file under test fixtures containing "secret-looking" strings as still worth flagging — test fixtures leak into git history too.
