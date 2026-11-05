# GitHub Actions Workflow Patterns

## Reusable Workflows

### Caller Workflow
```yaml
jobs:
  call-workflow:
    uses: org/repo/.github/workflows/reusable.yml@<40-hex-sha> # v1.0.0 — pin to a tag/SHA, never a branch like @main
    with:
      environment: production
    secrets:
      deploy_key: ${{ secrets.DEPLOY_KEY }}
```

### Reusable Workflow
```yaml
# .github/workflows/reusable.yml
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
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0
      - run: ./deploy.sh ${{ inputs.environment }}
```

## Matrix Builds

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node: [18, 20]
    exclude:
      - os: macos-latest
        node: 18
    include:
      - os: ubuntu-latest
        node: 20
        experimental: true
  fail-fast: false

steps:
  - uses: actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020 # v4.4.0
    with:
      node-version: ${{ matrix.node }}
```

## Environment Protection

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

## Concurrency Control

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

## Job Dependencies

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps: [...]
    
  test:
    needs: build
    runs-on: ubuntu-latest
    steps: [...]
    
  deploy:
    needs: [build, test]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
```

## Artifact Sharing

```yaml
- uses: actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02 # v4.6.2
  with:
    name: build-output
    path: dist/
    retention-days: 5

- uses: actions/download-artifact@d3f86a106a0bac45b974a628896c90dbdf5c8093 # v4.3.0
  with:
    name: build-output
    path: dist/
```

## Caching

```yaml
- uses: actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830 # v4.3.0
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```
