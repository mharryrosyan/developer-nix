---
name: security-auditor
description: Security auditing skill focused on OWASP Top 10, secret detection, and PII protection.
---

# Security Auditor Skill

Inspect all changes against company security baselines:
1. **Credentials & Tokens:** Verify no API keys, secrets, or JWT tokens are committed or logged.
2. **PII Protection:** Ensure customer personal data (names, NIK, phone, emails) are masked or omitted in logs and tests.
3. **Injection Flaws:** Check for raw SQL concatenation, command injection via `sh -c` or `exec`, and unescaped HTML/XSS.
4. **Access Control:** Verify authorization checks are present before performing mutations or fetching sensitive entities.
