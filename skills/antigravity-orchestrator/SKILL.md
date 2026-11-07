---
name: antigravity-orchestrator
description: Autonomous orchestration and programmatic workflow control via Antigravity CLI, subagent trees, and headless coding sessions.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Antigravity, Orchestration, Subagents, Automation, CodeMode, CLI]
---

# Antigravity Orchestrator & Multi-Subagent Control (Ibra X 3.1)

Pedoman arsitektur untuk mengorkestrasi sesi komputasi otonom headless, mendelegasikan tugas ke subagent spesialis, dan mengelola runtime Code Mode.

## 1. Topologi Delegasi Subagent Spesialis

Bagi tugas berskala besar menjadi cabang pohon eksekusi independen (*subagent tree*):

```text
               ┌───────────────────────┐
               │  ibra-x (Orkestrator) │
               └───────────┬───────────┘
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
   │   explore   │  │   builder   │  │  reviewer   │
   │ (Audit &    │  │ (Generasi   │  │ (Security & │
   │  Inspeksi)  │  │  Kode Fitur)│  │ Regression) │
   └─────────────┘  └─────────────┘  └─────────────┘
```

- **Explore Agent**: Khusus penelusuran struktur direktori dan analisis dependensi (read-only).
- **Builder / Coding Agent**: Modifikasi kode dengan granularitas presisi (edit tool).
- **Reviewer Agent**: Audit keamanan kode, sanitasi credential leaks, dan validasi standar arsitektur.

## 2. Orkestrasi Worktree & Isolasi Sesi Git

Gunakan git worktree terisolasi agar eksperimen refactoring tidak mengganggu branch aktif:

```bash
# Buat worktree terisolasi untuk fitur eksperimental
git worktree add ../feature-worktree -b feat/isolated-test

# Lakukan pengembangan dan pengujian di direktori tersebut
cd ../feature-worktree
# ... proses kerja ...

# Setelah selesai dan di-merge, bersihkan worktree
cd -
git worktree remove ../feature-worktree
```

## 3. Eksekusi Mandiri Tanpa Interupsi (Autonomous Loop)

1. **Investigasi Awal**: Identifikasi root cause atau spesifikasi kebutuhan.
2. **Implementasi Bertahap**: Eksekusi perubahan file demi file.
3. **Validasi Kualitas**: Jalankan test suite, linter, atau static check.
4. **Verifikasi Bukti**: Pastikan sistem berfungsi sebelum menyatakan tugas tuntas.
