---
name: cloudflare-workers-kv-d1
description: Komputasi edge Cloudflare Workers dengan integrasi KV Cache, basis data SQL D1, dan R2 Object Storage menggunakan Wrangler CLI.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Cloudflare, Serverless, Edge, Workers, KV, D1, SQLite, Storage]
---

# Cloudflare Workers, KV, and D1 Database (Ibra X 3.1)

Pola pengembangan aplikasi edge serverless dengan latensi sub-10ms menggunakan infrastruktur Cloudflare global network.

## 1. Konfigurasi `wrangler.toml`

```toml
name = "ibra-edge-worker"
main = "src/index.ts"
compatibility_date = "2024-11-01"

# KV Namespace Binding
[[kv_namespaces]]
binding = "CACHE_KV"
id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# D1 Serverless SQL Database Binding
[[d1_databases]]
binding = "DB"
database_name = "ibra-production-db"
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## 2. Implementasi Worker Edge dengan Cache & Query SQL (`src/index.ts`)

```typescript
export interface Env {
  CACHE_KV: KVNamespace;
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // 1. Endpoint Health Check
    if (url.pathname === "/health") {
      return new Response(JSON.stringify({ status: "OK", edge: "Cloudflare" }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    // 2. Cek Cache di Edge KV
    const cacheKey = `user:${url.pathname}`;
    const cached = await env.CACHE_KV.get(cacheKey);
    if (cached) {
      return new Response(cached, {
        headers: { "Content-Type": "application/json", "X-Cache": "HIT-EDGE" }
      });
    }

    // 3. Query Basis Data Serverless D1 jika Cache Miss
    try {
      const { results } = await env.DB.prepare(
        "SELECT id, name, email, created_at FROM users ORDER BY id DESC LIMIT 20"
      ).all();

      const payload = JSON.stringify({ data: results });

      // Simpan ke KV selama 60 detik
      await env.CACHE_KV.put(cacheKey, payload, { expirationTtl: 60 });

      return new Response(payload, {
        headers: { "Content-Type": "application/json", "X-Cache": "MISS" }
      });
    } catch (err: any) {
      return new Response(JSON.stringify({ error: err.message }), { status: 500 });
    }
  }
};
```

## 3. Perintah Migrasi Database D1 via CLI

```bash
# Buat tabel via migrasi lokal/remote
npx wrangler d1 execute ibra-production-db --command "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, email TEXT UNIQUE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);"

# Deploy langsung ke edge global
npx wrangler deploy
```
