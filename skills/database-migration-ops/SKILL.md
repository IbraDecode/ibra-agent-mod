---
name: database-migration-ops
description: Pola migrasi skema database zero-downtime (Expand-and-Contract pattern, non-blocking DDL, dan rollback validation).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Database, Migrations, ZeroDowntime, SQL, Schema, PostgreSQL, DevOps]
---

# Zero-Downtime Database Migration Protocols (Ibra X 3.1)

Metodologi pembaruan skema basis data produksi volume tinggi tanpa mengunci tabel (*table lock*) dan tanpa memutus ketersediaan layanan pengguna (*zero-downtime*).

## 1. Pola Desain Expand and Contract (Tiga Tahap)

Jangan pernah mengganti nama kolom secara langsung (`ALTER TABLE users RENAME COLUMN foo TO bar`):

1. **Fase 1: Expand (Peluasan)**:
   - Tambahkan kolom baru (`new_column`).
   - Kode aplikasi mulai menulis ke kedua kolom (`old_column` dan `new_column`), namun tetap membaca dari `old_column`.
   - Jalankan proses background worker untuk menyalin data lama ke kolom baru secara bertahap (*batch backfill*).
2. **Fase 2: Transition (Transisi)**:
   - Ubah kode aplikasi agar membaca data dari `new_column`.
3. **Fase 3: Contract (Penciutan)**:
   - Hapus penulisan ke `old_column` dan hapus kolom lama setelah seluruh instans aplikasi versi baru aktif.

## 2. Non-Blocking Index Creation di PostgreSQL

Hindari penguncian operasi baca/tulis saat membuat indeks pada tabel besar:

```sql
-- ❌ Mengunci tabel terhadap operasi INSERT/UPDATE
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- ✅ Aman untuk produksi (Non-blocking)
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders(user_id);
```

## 3. Penambahan Kolom dengan Nilai Default Aman

Pada versi PostgreSQL modern (11+), penambahan kolom `NOT NULL` dengan nilai default konstan tidak lagi menulis ulang seluruh tabel:
```sql
ALTER TABLE users ADD COLUMN is_verified BOOLEAN NOT NULL DEFAULT false;
```
