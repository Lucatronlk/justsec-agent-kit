"""Validate the repository report contract. Requires PyYAML; never installs it."""
import pathlib
import subprocess
import sys

import yaml


def validate(report, repository):
    data = yaml.safe_load(pathlib.Path(report).read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("Report must be a YAML mapping")
    required = "repository analysis documented_purpose architecture capabilities security_capabilities integration_surfaces extension_points reusable_components possible_extractions possible_wrappers architectural_limitations external_dependencies reuse_strategies evidence_summary confidence".split()
    if any(key not in data for key in required):
        raise ValueError("Missing report sections")
    if data.get("schema_version") != 1 or data.get("workflow_version") != 1:
        raise ValueError("Unsupported report version")
    root = pathlib.Path(repository).resolve()
    if pathlib.Path(data["repository"]["path"]).resolve() != root:
        raise ValueError("Report belongs to another repository")
    head = subprocess.run(["git", "-C", str(root), "rev-parse", "HEAD"], capture_output=True, text=True)
    commit = head.stdout.strip() if head.returncode == 0 else None
    if data["repository"]["git_commit"] != commit:
        raise ValueError("Report commit does not match checkout")
    strategies = set("USE_AS_IS CONFIGURE WRAP EXTEND FORK EXTRACT_COMPONENT REIMPLEMENT DO_NOT_USE".split())
    ids = set()
    capabilities = data["capabilities"]
    for bucket in "native undocumented repurposable minor_modification major_modification incompatible".split():
        for item in capabilities[bucket]:
            fields = "id name summary classification basis confidence evidence prerequisites limitations modifications reuse_strategy validation".split()
            if not isinstance(item, dict) or any(k not in item for k in fields):
                raise ValueError("Incomplete capability record")
            if item["id"] in ids:
                raise ValueError("Duplicate capability ID")
            ids.add(item["id"])
            if item["classification"] != bucket.upper():
                raise ValueError("Capability in wrong classification bucket")
            if item["basis"] not in {"SUPPORTED_BY_CODE", "INFERRED_FROM_ARCHITECTURE"}:
                raise ValueError("Invalid evidence basis")
            if item["reuse_strategy"] not in strategies or not item["evidence"]:
                raise ValueError("Missing evidence or invalid reuse strategy")
    for key, refs in [("implicit", capabilities["implicit"]), ("security", data["security_capabilities"])]:
        if not isinstance(refs, list) or any(ref not in ids for ref in refs):
            raise ValueError(f"Invalid {key} capability references")

    def walk(node):
        if isinstance(node, dict):
            if "confidence" in node and isinstance(node["confidence"], str):
                if node["confidence"] not in {"high", "medium", "low"}:
                    raise ValueError("Invalid confidence")
            if "line_start" in node or "line_end" in node:
                path = pathlib.Path(node["path"])
                source = (root / path).resolve()
                if path.is_absolute() or not source.is_relative_to(root):
                    raise ValueError("Evidence path escapes repository")
                start, end = node["line_start"], node["line_end"]
                # Count lines only; no source content is printed.
                if not (type(start) is int and type(end) is int and 1 <= start <= end <= len(source.read_bytes().splitlines())):
                    raise ValueError("Evidence line range is invalid")
                if not node.get("explanation") or node.get("kind") not in {"implementation", "configuration", "test", "documentation"}:
                    raise ValueError("Invalid evidence record")
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for item in node:
                walk(item)
    walk(data)
    analysis = data["analysis"]
    if analysis["status"] not in {"complete", "partial"}:
        raise ValueError("Invalid analysis status")
    if analysis["status"] == "partial":
        return 3
    if analysis["understand_anything"]["status"] not in {"current", "updated"}:
        raise ValueError("Complete report requires successful Understand Anything")
    if analysis["coverage"]["not_inspected"]:
        raise ValueError("Complete report has unfinished coverage")
    if not all(analysis["validation"].get(k) is True for k in ["yaml_parsed", "evidence_checked"]):
        raise ValueError("Complete report lacks validation")
    return 0


if __name__ == "__main__":
    try:
        result = validate(sys.argv[1], sys.argv[2])
        print("Valid partial report" if result == 3 else "Valid complete report")
        sys.exit(result)
    except (ValueError, KeyError, TypeError, OSError, yaml.YAMLError) as error:
        print(f"Invalid report: {error}", file=sys.stderr)
        sys.exit(1)
