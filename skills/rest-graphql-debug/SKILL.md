---
name: rest-graphql-debug
description: Debug REST/GraphQL APIs: status codes, auth, schemas, repro.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [API, REST, GraphQL, Debugging, Network, HTTP, Troubleshooting]
---

# REST & GraphQL API Diagnostic Protocol (Ibra X 3.1)

Panduan sistematis untuk mendiagnosis kegagalan komunikasi antarmuka pemrograman aplikasi (API), degradasi latensi, dan ketidaksesuaian skema payload.

## 1. Analisis Status Kode & Header HTTP

- **Status `401 Unauthorized` vs `403 Forbidden`**:
  - `401`: Token tidak ada, expired, atau format header `Authorization: Bearer <token>` salah.
  - `403`: Token valid tetapi tidak memiliki peran (*scope/permission*) untuk mengakses resource.
- **Status `429 Too Many Requests`**:
  Periksa header respons: `Retry-After`, `X-RateLimit-Limit`, `X-RateLimit-Remaining`, dan `X-RateLimit-Reset`.

## 2. Diagnostik GraphQL (Partial Errors)

Pada GraphQL, respons sering mengembalikan status HTTP `200 OK` meskipun eksekusi query gagal:
```json
{
  "errors": [
    {
      "message": "Cannot query field 'nonExistentField' on type 'User'.",
      "locations": [{ "line": 2, "column": 3 }],
      "extensions": { "code": "GRAPHQL_VALIDATION_FAILED" }
    }
  ],
  "data": null
}
```
Pastikan parser selalu memeriksa keberadaan kunci `errors` dalam JSON sebelum memproses `data`.
