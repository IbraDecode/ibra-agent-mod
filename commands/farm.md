---
description: Eksekusi otomatisasi web farming, pembuatan akun, dan bypass proteksi
---

Jalankan orkestrasi farming untuk target berikut menggunakan metodologi Ibra X 3.1:
$ARGUMENTS

Alur kerja:
1. Lakukan recon endpoint dan proteksi WAF (Cloudflare/Turnstile/reCAPTCHA).
2. Prioritaskan jalur pure HTTP (curl_cffi impersonate) sebelum browser.
3. Kelola rotasi proxy dan email temporary secara otomatis.
4. Simpan output ke format terstruktur (JSON/CSV).
