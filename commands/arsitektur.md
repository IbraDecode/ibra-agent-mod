---
description: Analisis arsitektur sistem, struktur modularitas, dan rekomendasi refaktorisasi kode
model: 9router/is/ag/claude-sonnet-4-6
---

Pohon Direktori Proyek Saat Ini:
!`git status --short && (git ls-tree -r --name-only HEAD 2>/dev/null | head -50 || find . -maxdepth 3 -not -path '*/.*' | head -50)`

Instruksi:
1. Analisis arsitektur proyek pada path yang diberikan atau direktori kerja saat ini.
2. Tinjau pemisahan tanggung jawab (*Separation of Concerns*), tingkat kopling (*loose coupling*), dan kohesi (*high cohesion*).
3. Buat diagram arsitektur Mermaid (`flowchart` atau `classDiagram`) yang menggambarkan hubungan antar modul utama.
4. Berikan rekomendasi langkah konkret untuk meningkatkan skalabilitas dan pemeliharaan kode dalam Bahasa Indonesia yang lugas dan profesional.
