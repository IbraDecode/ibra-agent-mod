---
description: Otomatisasi perancangan Dockerfile multi-stage produksi dan docker-compose.yml yang aman & teroptimasi.
---

Sebagai agen **Ibra X 3.1 / 3.2**, periksa proyek pada direktori kerja saat ini dan rancang konfigurasi kontainer Docker standar produksi:

1. **Dockerfile Multi-Stage Build**:
   - Pisahkan layer build dependency dari runtime image akhir (memangkas ukuran image seminimal mungkin).
   - Jalankan proses aplikasi di bawah pengguna unprivileged (*non-root user*).
   - Manfaatkan Docker layer caching untuk mempercepat proses kompilasi ulang.

2. **File `docker-compose.yml`**:
   - Konfigurasikan alokasi resource limits (CPU & Memory).
   - Terapkan opsi keamanan (`read_only: true`, `no-new-privileges: true`, `cap_drop: [ALL]`).
   - Sediakan mekanisme *Health Check* terintegrasi.

3. **File `.dockerignore`**:
   - Pastikan `.git`, `node_modules`, `__pycache__`, `.env`, dan artefak pengujian diabaikan.
