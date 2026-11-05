---
name: github-actions
description: Build, test, and deploy applications using GitHub Actions workflows. Create CI/CD pipelines, configure runners, manage secrets, and automate software delivery. Use when working with GitHub repositories, automating builds, running tests, or deploying applications.
license: MIT
metadata:
  author: devops-skills
  version: "1.0"
---

# GitHub Actions

Automate software workflows directly in your GitHub repository with GitHub Actions.

## When to Use This Skill

Use this skill when:
- Setting up CI/CD pipelines for GitHub repositories
- Automating build, test, and deployment workflows
- Creating reusable workflow components
- Configuring self-hosted runners
- Managing workflow secrets and variables
- Debugging failed workflow runs

## Prerequisites

- GitHub repository with write access
- Understanding of YAML syntax
- For self-hosted runners: server with Docker (optional)

## Workflow File Structure

> Third-party actions in these examples are pinned to a full commit SHA with a `# vX.Y.Z` comment. See **Security Notes** at the end for why, and how to refresh the pins.

Workflows are defined in `.github/workflows/` directory:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0
      - name: Setup Node.js
        uses: actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020 # v4.4.0
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
```

## Common Triggers

### Push and Pull Request

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'src/**'
      - 'package.json'
  pull_request:
    branches: [main]
```

### Scheduled Runs

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC
```

### Manual Dispatch

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
```

## Job Configuration

### Matrix Builds

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 22]
        os: [ubuntu-latest, windows-latest]
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0
      - uses: actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020 # v4.4.0
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

### Job Dependencies

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: npm run build
      
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: npm test
      
  deploy:
    needs: [build, test]
    runs-on: ubuntu-latest
    steps:
      - run: ./deploy.sh
```

### Environment Protection

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - run: ./deploy.sh
```

## Secrets and Variables

### Using Secrets

```yaml
steps:
  - name: Deploy
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    run: aws s3 sync ./dist s3://my-bucket
```

### Using Variables

```yaml
steps:
  - name: Build
    env:
      API_URL: ${{ vars.API_URL }}
    run: npm run build
```

## Caching Dependencies

```yaml
- uses: actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830 # v4.3.0
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Artifacts

### Upload Artifacts

```yaml
- uses: actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02 # v4.6.2
  with:
    name: build-output
    path: dist/
    retention-days: 5
```

### Download Artifacts

```yaml
- uses: actions/download-artifact@d3f86a106a0bac45b974a628896c90dbdf5c8093 # v4.3.0
  with:
    name: build-output
    path: dist/
```

## Docker Builds

```yaml
jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0
      
      - name: Login to Docker Hub
        uses: docker/login-action@c94ce9fb468520275223c153574b00df6fe4bcc9 # v3.7.0
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@ca052bb54ab0790a636c9b5f226502c73d547a25 # v5.4.0
        with:
          context: .
          push: true
          tags: user/app:${{ github.sha }}   # immutable tag; never push a floating :latest as the only tag
```

## Reusable Workflows

### Define Reusable Workflow

```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      deploy_key:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - run: echo "Deploying to ${{ inputs.environment }}"
```

### Call Reusable Workflow

```yaml
jobs:
  deploy-staging:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
    secrets:
      deploy_key: ${{ secrets.STAGING_KEY }}
```

## Self-Hosted Runners

### Register Runner

```bash
# Download runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf actions-runner-linux-x64.tar.gz

# Configure
./config.sh --url https://github.com/OWNER/REPO --token TOKEN

# Run
./run.sh
```

### Use Self-Hosted Runner

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0
```

## Debugging Workflows

### Enable Debug Logging

Set repository secrets:
- `ACTIONS_RUNNER_DEBUG`: `true`
- `ACTIONS_STEP_DEBUG`: `true`

### Debug Step

```yaml
- name: Debug
  run: |
    echo "GitHub context: ${{ toJson(github) }}"
    echo "Job context: ${{ toJson(job) }}"
```

## Common Issues

### Issue: Workflow Not Triggering
**Problem**: Workflow doesn't run on push/PR
**Solution**: Check branch filters, path filters, and ensure workflow file is on the default branch

### Issue: Permission Denied
**Problem**: Actions can't push or create PRs
**Solution**: Configure `permissions` in workflow or update repository settings

```yaml
permissions:
  contents: write
  pull-requests: write
```

### Issue: Cache Not Restoring
**Problem**: Cache misses despite existing cache
**Solution**: Verify cache key matches exactly, check runner OS

## Best Practices

- Pin third-party actions to a **full commit SHA** with a `# vX.Y.Z` comment — never a tag, never a branch
- Use caching for dependencies to speed up builds
- Minimize secrets exposure with environment scoping
- Use matrix builds for cross-platform testing
- Use `continue-on-error` only for a step you *intend* to be non-blocking — never to mask a failing gate (see `instructions/ai-agents/never-weaken.instructions.md`)
- Keep workflows DRY with reusable workflows and composite actions

## Security Notes

The examples pin third-party actions to a full commit SHA with a `# vX.Y.Z` comment (resolved 2026-10-17), so a moved or compromised tag cannot change what runs. Refresh with Dependabot (`github-actions` ecosystem) or Renovate. Canonical pinned forms: `skills/security/scanning/supply-chain-attack-response/SKILL.md`; review checklist: `skills/devsecops/pipeline-security-review/SKILL.md`.

- **Least privilege by default.** Set `permissions: {}` or `contents: read` at the top level and grant elevated scopes per job only where needed.
- **Never interpolate untrusted context into `run:`.** `github.event.issue.title`, `github.head_ref`, branch names and commit messages are attacker-controlled; `${{ }}` is textual substitution into the shell. Pass them via `env:` and reference `"$VAR"` quoted.
- **Reusable workflows: the caller must grant every permission and secret the callee declares.** They are checked statically at parse time, so a mismatch ends every run in `startup_failure` before any job starts.
- **Pin third-party reusable workflows to a tag or SHA, never a branch** (`@v1.2.3` or `@<sha>`, never `@main`).
- **Bind artifacts between jobs.** The consumer must use the exact bytes an earlier job produced (image by digest, SBOM as an artifact), not a re-pulled mutable tag.
- Use `actions/checkout` with `persist-credentials: false` when the job does not push.

## Related Skills

- [gitlab-ci](../gitlab-ci/) - GitLab CI/CD alternative
- [docker-management](../../containers/docker-management/) - Container builds
- [semantic-versioning](../../release/semantic-versioning/) - Automated releases
