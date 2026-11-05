---
name: dast-scanning
description: Perform dynamic application security testing with OWASP ZAP, Burp Suite, and Nikto. Test running applications for security vulnerabilities through automated and manual testing. Use when testing web applications, APIs, or performing penetration testing.
license: MIT
metadata:
  author: devops-skills
  version: "1.0"
---

# DAST Scanning

Test running applications for security vulnerabilities through dynamic analysis.

## When to Use This Skill

Use this skill when:
- Testing deployed applications
- Performing automated security scans
- Finding runtime vulnerabilities
- Testing authentication flows
- Validating API security

## Prerequisites

- Running application instance
- Network access to target
- Testing authorization
- Understanding of web security

## Tool Overview

| Tool | Type | Best For |
|------|------|----------|
| OWASP ZAP | OSS | Automated scanning, CI |
| Burp Suite | Commercial | Manual testing, advanced |
| Nikto | OSS | Web server scanning |
| Nuclei | OSS | Template-based scanning |
| Arachni | OSS | Comprehensive scanning |

## OWASP ZAP

> Images are pinned by digest and actions by commit SHA in these examples (resolved 2026-10-17), so a repointed tag cannot change what runs. Refresh a digest with `docker buildx imagetools inspect <repo>:<tag>` against the tag you track, and the actions with Dependabot (`github-actions` ecosystem) or Renovate.

### Docker Setup

```bash
# Run ZAP in daemon mode
docker run -d --name zap \
  -p 8080:8080 \
  -v $(pwd)/reports:/zap/reports \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap.sh -daemon -host 0.0.0.0 -port 8080 \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true
```

### Baseline Scan

```bash
# Quick baseline scan
docker run --rm -v $(pwd):/zap/wrk \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap-baseline.py -t https://target.example.com \
  -r baseline-report.html

# With authentication
docker run --rm -v $(pwd):/zap/wrk \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap-baseline.py -t https://target.example.com \
  -r report.html \
  --auth-login-url https://target.example.com/login \
  --auth-username user \
  --auth-password pass
```

### Full Scan

```bash
# Comprehensive scan
docker run --rm -v $(pwd):/zap/wrk \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap-full-scan.py -t https://target.example.com \
  -r full-report.html \
  -J full-report.json
```

### API Scan

```bash
# OpenAPI specification scan
docker run --rm -v $(pwd):/zap/wrk \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap-api-scan.py -t https://target.example.com/openapi.json \
  -f openapi \
  -r api-report.html
```

### ZAP Automation Framework

```yaml
# zap-automation.yaml
env:
  contexts:
    - name: "Default Context"
      urls:
        - "https://target.example.com"
      includePaths:
        - "https://target.example.com/.*"
      excludePaths:
        - "https://target.example.com/logout.*"
      authentication:
        method: "form"
        parameters:
          loginUrl: "https://target.example.com/login"
          loginRequestData: "username={%username%}&password={%password%}"
        verification:
          method: "response"
          loggedInRegex: "\\QWelcome\\E"
      users:
        - name: "testuser"
          credentials:
            username: "test@example.com"
            password: "password123"

jobs:
  - type: spider
    parameters:
      context: "Default Context"
      user: "testuser"
      maxDuration: 10
      
  - type: spiderAjax
    parameters:
      context: "Default Context"
      user: "testuser"
      maxDuration: 10
      
  - type: passiveScan-wait
    parameters:
      maxDuration: 5
      
  - type: activeScan
    parameters:
      context: "Default Context"
      user: "testuser"
      policy: "Default Policy"
      
  - type: report
    parameters:
      template: "traditional-html"
      reportDir: "/zap/reports"
      reportFile: "zap-report"
```

```bash
# Run automation
docker run --rm -v $(pwd):/zap/wrk \
  ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6 \
  zap.sh -cmd -autorun /zap/wrk/zap-automation.yaml
```

## ZAP Context, Scope And Sign-In Gotchas

The context file decides what ZAP will actually touch. It is easy to author one that scans the wrong target, or that "signs in" and then scans unauthenticated.

- **Parse the context with ZAP's own reader, not a generic XML walk.** A `itertext()`-style check accepted a *mixed-content* login URL (text split around a child element) that ZAP rejected; CDATA-wrapped values bypass naive text readers too. Validate with ZAP's semantics, or run ZAP and read its error — not a hand-rolled parse.
- **Scope regexes are Java regexes, not Python/JS.** `\Q...\E` (as used in the `loggedInRegex` above), possessive/lazy quantifiers, inline flags, `\x2f` and top-level `|` all behave Java's way. Check a pattern with `java.util.regex.Pattern` before trusting it; an unanchored top-level `|` silently widens scope to everything.
- **Keep scope loopback-only** for a local target. `host:80@evil` (userinfo), decimal/IPv4-mapped IPv6 forms, and trailing-dot hostnames (`evil.example.com.`) each defeat a naive string `includes`.
- **Prove the login worked.** A "signed in" claim must come from a *protected* request returning authenticated content as the selected user, and it must fail closed. A failed login that keeps scanning unauthenticated produces a clean report for the wrong reason.

Source: `ChiefGyk3D/department-of-internal-arguments` pack `gha-security-dast` (MIT, © 2026 ChiefGyk3D).

## CI/CD Integration

### GitHub Actions

```yaml
name: DAST Scan

on:
  workflow_dispatch:
  schedule:
    - cron: '0 2 * * *'

jobs:
  dast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4.4.0

      - name: Start Application
        run: |
          docker-compose up -d
          sleep 30  # Wait for app to be ready

      - name: OWASP ZAP Scan
        uses: zaproxy/action-full-scan@77c40179ecb960ceb784da5f370ad6285ebcf1cb # v0.8.0
        with:
          target: 'http://localhost:8080'
          rules_file_name: '.zap/rules.tsv'
          cmd_options: '-a'

      - name: Upload Report
        uses: actions/upload-artifact@ea165f8d65b6e75b540449e92b4886f43607fa02 # v4.6.2
        if: always()
        with:
          name: zap-report
          path: report_html.html
```

### GitLab CI

```yaml
dast:
  stage: security
  image: ghcr.io/zaproxy/zaproxy@sha256:5ccfff9a411743ab2615136a2edd7416bec9ce41572fa94e935df38c14adb2b6
  variables:
    TARGET_URL: $DAST_TARGET_URL
  script:
    - mkdir -p /zap/wrk/reports
    - zap-baseline.py -t $TARGET_URL -r /zap/wrk/reports/zap-report.html -I
  artifacts:
    paths:
      - reports/
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

## Burp Suite Automation

### REST API Usage

```python
import requests

class BurpScanner:
    def __init__(self, api_url, api_key):
        self.api_url = api_url
        self.headers = {'Authorization': api_key}
    
    def create_scan(self, target_url):
        """Create and start a new scan."""
        payload = {
            'scan_configurations': [
                {'name': 'Crawl and Audit - Balanced'}
            ],
            'scope': {
                'include': [{'rule': target_url}]
            },
            'urls': [target_url]
        }
        response = requests.post(
            f'{self.api_url}/v0.1/scan',
            json=payload,
            headers=self.headers
        )
        return response.headers.get('Location')
    
    def get_scan_status(self, scan_id):
        """Get scan status."""
        response = requests.get(
            f'{self.api_url}/v0.1/scan/{scan_id}',
            headers=self.headers
        )
        return response.json()
    
    def get_issues(self, scan_id):
        """Get scan issues."""
        response = requests.get(
            f'{self.api_url}/v0.1/scan/{scan_id}/issues',
            headers=self.headers
        )
        return response.json()

# Usage
scanner = BurpScanner('http://burp:1337', 'api-key')
scan_id = scanner.create_scan('https://target.example.com')

while True:
    status = scanner.get_scan_status(scan_id)
    if status['scan_status'] == 'succeeded':
        break
    time.sleep(30)

issues = scanner.get_issues(scan_id)
```

## Nikto

### Basic Scanning

```bash
# Install
apt-get install nikto

# Basic scan
nikto -h https://target.example.com

# With specific options
nikto -h https://target.example.com \
  -ssl \
  -Tuning 123bde \
  -output nikto-report.html \
  -Format html

# Scan specific ports
nikto -h target.example.com -p 80,443,8080
```

## Common DAST Findings

### OWASP Top 10

```yaml
owasp_findings:
  A01_Broken_Access_Control:
    - IDOR vulnerabilities
    - Missing function-level access control
    - Privilege escalation
    
  A02_Cryptographic_Failures:
    - Sensitive data in URLs
    - Missing HTTPS
    - Weak ciphers
    
  A03_Injection:
    - SQL injection
    - Command injection
    - XSS
    
  A05_Security_Misconfiguration:
    - Default credentials
    - Verbose error messages
    - Missing security headers
    
  A07_Auth_Failures:
    - Weak passwords accepted
    - Session fixation
    - Missing MFA
```

## Security Headers Check

```bash
# Check security headers
curl -I https://target.example.com | grep -i "x-\|content-security\|strict"

# Expected headers:
# X-Content-Type-Options: nosniff
# X-Frame-Options: DENY
# X-XSS-Protection: 1; mode=block
# Content-Security-Policy: default-src 'self'
# Strict-Transport-Security: max-age=31536000
```

## Custom Test Cases

```yaml
# Test authentication
tests:
  - name: "Authentication Bypass"
    steps:
      - Access protected resource without auth
      - Verify 401/403 response
      - Access with valid auth
      - Verify 200 response
    
  - name: "Session Management"
    steps:
      - Login and capture session token
      - Logout
      - Attempt to use old session
      - Verify session invalidated
    
  - name: "Input Validation"
    steps:
      - Submit XSS payload in all inputs
      - Submit SQL injection in all inputs
      - Verify proper sanitization
```

## Common Issues

### Issue: False Positives
**Problem**: Scanner reports non-vulnerabilities
**Solution**: Configure scan policy, review findings manually

### Issue: Missing Authentication
**Problem**: Cannot scan authenticated areas
**Solution**: Configure authentication context, use session tokens

### Issue: Incomplete Coverage
**Problem**: Scanner misses endpoints
**Solution**: Import API specs, improve spidering, use authenticated scanning

## Best Practices

- Test in staging environment first
- Configure proper authentication
- Import API specifications for complete coverage
- Review findings before reporting
- Combine with manual testing
- Run regular scans (weekly minimum)
- Track findings over time
- Coordinate with development team

## Related Skills

- [sast-scanning](../sast-scanning/) - Static analysis
- [penetration-testing](../../operations/penetration-testing/) - Manual testing
- [waf-setup](../../network/waf-setup/) - WAF configuration
