---
name: git-workflow
description: Standar pembuatan commit message (Conventional Commits), pengelolaan branch, dan deskripsi Pull Request.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Git, ConventionalCommits, Branching, Workflow, PullRequest, DevOps]
---

# Git Workflow & Commit Standards (Ibra X 3.1)

Pedoman standar manajemen riwayat commit dan pemeliharaan cabang Git untuk agen otonom dan pengembang perangkat lunak.

## 1. Format Conventional Commits 1.0.0

Struktur commit:
```text
<type>(<scope>): <deskripsi singkat imperatif>

[penjelasan opsional mengenai latar belakang dan dampak perubahan]

[footer opsional: Breaking Change atau Issue Reference]
```

Daftar tipe commit:
- `feat`: Penambahan fitur baru ke sistem.
- `fix`: Perbaikan bug atau celah sistem.
- `perf`: Peningkatan performa kode atau efisiensi memori.
- `refactor`: Perubahan struktur kode tanpa mengubah fungsionalitas luar.
- `chore`: Tugas pemeliharaan rutin, konfigurasi dependensi, atau skrip build.
- `docs`: Modifikasi dokumentasi atau komentar kode.

## 2. Praktik Kebersihan Cabang (Branch Hygiene)

- Jangan pernah melakukan force push langsung ke cabang utama (`main`/`master`).
- Gunakan `--force-with-lease` saat memperbarui cabang fitur hasil rebase:
  ```bash
  git push --force-with-lease origin feat/modul-fitur
  ```
- Bersihkan cabang lokal yang telah di-merge secara periodik:
  ```bash
  git branch --merged main | grep -v 'main$' | xargs git branch -d
  ```
