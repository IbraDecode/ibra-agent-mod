---
name: database-ops
description: Operasi automasi basis data (PostgreSQL, MySQL, SQLite, Redis), inspeksi skema, ekspor/impor data, dan deteksi query lambat.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Database, SQL, PostgreSQL, MySQL, SQLite, Redis, Optimization]
---

# Database Operations & Performance Profiler (Ibra X 3.1)

Panduan operasional dan automasi administrasi basis data SQL & NoSQL untuk agen pengembang dan teknisi sistem.

## 1. SQLite Quick Diagnostics & Backup

```bash
# Periksa integritas database SQLite
sqlite3 app.db "PRAGMA integrity_check;"

# Backup hot database tanpa memutus koneksi aplikasi
sqlite3 app.db ".backup app_backup.db"

# Analisis ukuran tabel dan indeks
sqlite3 app.db "SELECT name, type FROM sqlite_master WHERE type IN ('table', 'index');"
```

## 2. PostgreSQL Management

```bash
# Backup database terkompresi
pg_dump -U postgres -d nama_db -Fc -f backup_$(date +%Y%m%d).dump

# Deteksi query lambat atau koneksi menggantung (blocking queries)
psql -U postgres -d nama_db -c "
SELECT pid, age(clock_timestamp(), query_start), usename, query 
FROM pg_stat_activity 
WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY query_start asc;"

# Terminate query yang memblokir
psql -U postgres -c "SELECT pg_terminate_backend(<PID>);"
```

## 3. Redis In-Memory Diagnostics

```bash
# Cek penggunaan memori dan fragmentasi
redis-cli info memory | grep -E "(used_memory_human|mem_fragmentation_ratio)"

# Pantau request real-time
redis-cli monitor | head -50

# Analisis kunci dengan ukuran memori terbesar
redis-cli --bigkeys
```
