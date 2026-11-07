---
description: Buat pesan commit Git terstandar (Conventional Commits) dari perubahan aktif
model: 9router/is/ag/claude-sonnet-4-6
---

Periksa status dan diff Git saat ini:
!`git status -s && git diff --cached`

Tugas:
1. Ringkas perubahan inti secara padat.
2. Formulasikan pesan commit dengan format Conventional Commits: `<type>(<scope>): <deskripsi singkat>`.
3. Jika pengguna memberikan catatan tambahan: $ARGUMENTS, padukan ke dalam pesan commit.
4. Tampilkan pesan commit final dalam format blok kode yang siap di-copy atau dijalankan via `git commit -m "..."`.
