---
name: api-standards
description: API design validation skill enforcing RESTful conventions, error formats, and idempotency.
---

# API Standards Skill

Review API endpoints and schemas:
1. **HTTP Methods & Status:** Use appropriate HTTP verbs (GET for safe reads, POST for creation, PUT/PATCH for mutation, DELETE for removal). Ensure correct status codes (200, 201, 204, 400, 401, 403, 404, 422).
2. **Error Responses:** Ensure error responses follow the standard JSON envelope:
   `{"error": {"code": "RESOURCE_NOT_FOUND", "message": "Descriptive message"}}`.
3. **Idempotency:** Require idempotency keys for critical financial or state-altering endpoints.
