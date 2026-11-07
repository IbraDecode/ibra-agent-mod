---
name: opencode-orchestrator
description: Autonomous orchestration and programmatic workflow control via OpenCode CLI, subagent trees, and headless coding sessions
---

# OpenCode Orchestrator Skill

Panduan orkestrasi otonom menggunakan OpenCode CLI untuk automasi coding massal, refactoring, dan eksekusi tugas bertahap:

## 1. Mode Eksekusi Headless & Skrip
Jalankan OpenCode tanpa interaksi manual untuk pipeline otomatis:
```bash
# Eksekusi prompt sekali jalan dengan model spesifik
opencode run -m 9router/is/ibra "Terapkan migrasi skema database terbaru"

# Delegasikan ke subagent khusus
opencode run --agent architect "Buat spesifikasi API untuk modul auth"
opencode run --agent reviewer "Audit perubahan kode terkini"
```

## 2. Struktur Subagent & Konkurensi
- **Primary Agent (`build`)**: Mengelola kontrol alur dan koordinasi utama.
- **Subagent (`explore`)**: Melakukan pencarian file, analisis AST, dan grepping tanpa memodifikasi kode.
- **Subagent (`reviewer`)**: Memvalidasi diff secara read-only sebelum merge.

## 3. Otomasi Diff & Commit Pipeline
Kombinasikan dengan git dan toolchain:
```bash
# 1. Jalankan perbaikan
opencode run "/perbaiki 'Perbaiki race condition pada worker pool'"
# 2. Validasi status
git diff --stat
# 3. Otomatisasi commit terstandar
opencode run "/komit 'fix race condition worker pool'"
```
