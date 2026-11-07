---
name: autonomous-git-ops
description: Automasi manajemen cabang Git, pembuatan Pull Request otomatis via gh CLI, resolusi konflik merge, dan alur rilis berstandar.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Git, GitHub, DevOps, CI/CD, Pull Request, Automation]
---

# Autonomous Git Ops (Ibra X 3.1)

Prosedur standar untuk agen otonom dalam mengelola branch, sinkronisasi repositori, pembuatan Pull Request, dan penanganan konflik tanpa intervensi manual yang tidak perlu.

## 1. Siklus Pembuatan Fitur & Cabang (Feature Branching)

```bash
# Buat dan beralih ke cabang fitur baru dari main
git checkout main
git pull origin main
git checkout -b feat/nama-fitur-baru

# Lakukan perubahan dan verifikasi diff
git status -s
git diff

# Buat commit dengan standar Conventional Commits
git add -A
git commit -m "feat(scope): penjelasan singkat perubahan"

# Push cabang ke remote
git push -u origin feat/nama-fitur-baru
```

## 2. Pembuatan Pull Request Otomatis via GitHub CLI (`gh`)

```bash
gh pr create \
  --base main \
  --head feat/nama-fitur-baru \
  --title "feat(scope): penjelasan singkat fitur" \
  --body "## Ringkasan Perubahan
- Menambahkan fitur X
- Memperbaiki penanganan error pada modul Y

## Pengujian
- Unit test berhasil (100% pass)
- Linting dan format tervalidasi"
```

## 3. Resolusi Konflik Merge Secara Otonom

Jika terjadi merge conflict saat rebase atau merge:
```bash
# 1. Fetch perubahan terbaru dari remote
git fetch origin

# 2. Rebase cabang fitur terhadap main terbaru
git rebase origin/main

# 3. Jika konflik terjadi:
# Identifikasi file yang berkonflik
git status -s | grep "^UU"

# Analisis penanda konflik (<<<<<<<, =======, >>>>>>>)
# Pilih strategi: keep both, take incoming, atau dekomposisi logika
# Setelah selesai diedit:
git add <file-konflik>
git rebase --continue

# 4. Push hasil rebase yang bersih
git push --force-with-lease origin feat/nama-fitur-baru
```
