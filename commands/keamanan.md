---
description: Audit keamanan mendalam, deteksi kebocoran kredensial, dan analisis kerentanan OWASP
model: 9router/is/ag/claude-opus-4-6-thinking
---

Data Diff & File Perubahan Terkini:
!`git diff HEAD~1 2>/dev/null || git diff --staged 2>/dev/null || git status --short`

Pemeriksaan Residu Secret/Key:
!`git grep -E "((sk-[a-zA-Z0-9]{20,})|(ghp_[a-zA-Z0-9]{20,})|(password\s*=\s*['\"][^'\"]+['\"]))" 2>/dev/null | head -10 || echo "Tidak ada pola kredensial eksplisit terdeteksi"`

Instruksi:
1. Lakukan audit keamanan proaktif terhadap kode dan konfigurasi proyek.
2. Identifikasi potensi kerentanan:
   - Injeksi (SQL Injection, Command Injection, Server-Side Template Injection).
   - Penanganan autentikasi & otorisasi yang cacat (IDOR, Broken Access Control).
   - Kebocoran rahasia (*secret exposure*), token API, atau kredensial hardcoded.
   - Izin file berbahaya dan ketidakamanan konfigurasi runtime.
3. Laporkan setiap temuan dengan tingkat keparahan (*Critical / High / Medium / Low*), bukti baris kode (*PoC*), dan kode perbaikan (*Remediation*) yang aman.
