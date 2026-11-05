#!/usr/bin/env python3
"""Read-only structural validation for six local agent definitions; not a runtime permission test."""
from __future__ import annotations

import json
from pathlib import Path
import sys

import yaml

import importlib.util

spec = importlib.util.spec_from_file_location('skill_sync', Path(__file__).with_name('sync-agent-skill-permissions.py'))
assert spec and spec.loader
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)
AGENTS, ROOT, index_mapping, Invalid, UNIVERSAL = sync.AGENTS, sync.ROOT, sync.index_mapping, sync.Invalid, sync.UNIVERSAL

SHARED = set('''adversarial-review asset-inventory documentation-writer pr-risk-summary readme-generator repo-ai-readiness repo-intelligence understand understand-chat understand-dashboard understand-diff understand-domain understand-explain understand-figma understand-knowledge understand-onboard architecture-mapping change-impact-analysis dependency-graph technical-debt-analysis'''.split())
SECTIONS = ('Role', 'Delegation', 'Skill selection', 'Operating modes', 'Workflow')
EXCLUDED = {'blue-green-deploy', 'opentofu-migration', 'semantic-versioning', 'terraform-review'}


def check() -> None:
    config = json.loads((ROOT / 'opencode.json').read_text())
    assert set(config) == {'$schema', 'instructions', 'skills'}, 'unsupported top-level config field'
    assert config['$schema'] == 'https://opencode.ai/config.json', 'unexpected config schema'
    assert isinstance(config['instructions'], list) and len(config['instructions']) == len(set(config['instructions'])), 'invalid or duplicate instruction paths'
    assert all(isinstance(item, str) and item.startswith(('AGENTS.md', 'STANDARDS.md', 'instructions/')) and '..' not in Path(item).parts and (ROOT / item).is_file() for item in config['instructions']), 'missing or unsafe instruction file'
    assert 'instructions/ai-agents/report-header.instructions.md' in config['instructions'], 'report header not configured'
    assert config['skills'] == {'paths': ['skills']} and (ROOT / 'skills').is_dir(), 'skill discovery differs'
    mapping = index_mapping()
    assert len(AGENTS) == 7 and SHARED <= set.intersection(*(mapping[a] for a in AGENTS)), 'shared grant missing'
    assert not (EXCLUDED & mapping['migration-agent']), 'migration exclusion violated'
    for agent in AGENTS:
        source = (ROOT / 'agents' / f'{agent}.md').read_text()
        _, fm, body = source.split('---', 2)
        doc = yaml.safe_load(fm)
        assert isinstance(doc, dict) and doc.get('name') == agent and doc.get('mode') == 'all', f'{agent}: identity/mode'
        assert set(doc) == {'name', 'description', 'mode', 'permission'}, f'{agent}: unexpected frontmatter key'
        assert doc['description'].strip() and len(body.strip()) > 1100, f'{agent}: placeholder body'
        perms = doc['permission']
        assert set(perms) == {'edit', 'bash', 'external_directory', 'read', 'skill'}, f'{agent}: permission keys'
        if agent in UNIVERSAL:
            assert isinstance(perms['bash'], dict) and perms['bash'].get('*') == 'allow', f'{agent}: unrestricted shell'
            assert [perms['bash'].get(c) for c in ('git commit *', 'git push *', 'sudo *')] == ['ask'] * 3, f'{agent}: missing shell prompt'
            assert perms['edit'] == 'allow' and perms['read'] == 'allow' and perms['external_directory'] == 'allow', f'{agent}: restriction remains'
            assert perms['skill'] == {'*': 'allow'} and mapping[agent], f'{agent}: skill mismatch'
        else:
            assert perms['bash'] == 'ask', f'{agent}: shell approval'
            expected_edit = {'*': 'allow', **{k: 'deny' for k in ('*.env', '*.env.*', '*.pem', '*.key', '*credentials*', '*kubeconfig*', '*/.ssh/*', '.netrc', '*.p12', '*.pfx', '*.tfstate')}}
            assert perms['edit'] == expected_edit, f'{agent}: portable edit policy / protected paths'
            assert perms['external_directory'] == {'*': 'ask', '$HOME/justsec-agent-kit/skills/**': 'allow', '$HOME/.config/opencode/skill/**': 'allow'}, f'{agent}: portable skill path scope'
            assert perms['read'].get('*') == 'allow' and all(perms['read'].get(k) == 'deny' for k in ('*.env', '*.env.*', '*.pem', '*.key', '*credentials*', '*kubeconfig*', '*/.ssh/*', '.netrc', '*.p12', '*.pfx', '*.tfstate')), f'{agent}: credential read rule'
            assert perms['skill'].get('*') == 'deny' and {k for k, v in perms['skill'].items() if v == 'allow'} == mapping[agent], f'{agent}: skill mismatch'
        assert all('## ' + s in body for s in SECTIONS), f'{agent}: required section missing'
        assert '## Output' in body and ('## Security' in body or '## Permission and secret controls' in body), f'{agent}: security/output section missing'
        for mode in ('Analysis/audit', 'Planning', 'Implementation', 'Troubleshooting'):
            assert '**' + mode + ':**' in body and len(body.split('**' + mode + ':**', 1)[1].split('\n', 1)[0]) > 95, f'{agent}: thin mode {mode}'
        for term in ('[REDACTED]', 'rollback', 'not', 'skill-agent-index.md'):
            assert term in body.lower() if term != '[REDACTED]' else term in body, f'{agent}: missing {term}'
    print(f'OK: seven agent frontmatter/body contracts; {len(SHARED)} shared grants; {len(config["instructions"])} instruction paths checked')


if __name__ == '__main__':
    try:
        check()
    except (AssertionError, Invalid, KeyError, ValueError, yaml.YAMLError, OSError) as exc:
        print(f'FAIL: {exc}', file=sys.stderr)
        sys.exit(1)
