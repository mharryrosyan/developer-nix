---
name: code-reviewer
description: Automated code review skill enforcing company standards, error handling, and maintainability.
---

# Code Reviewer Skill

When asked to review code, PRs, or diffs:
1. **Correctness & Edge Cases:** Check for null/undefined handling, race conditions, and boundary conditions.
2. **Performance:** Highlight unnecessary allocations, unindexed queries, or blocking I/O.
3. **Clean Code & Slop Prevention:** Ensure code is concise and idiomatic. Avoid speculative abstractions (YAGNI).
4. **Format:** Provide feedback ranked by severity (Critical, Warning, Suggestion).
