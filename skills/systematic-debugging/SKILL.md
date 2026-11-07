---
name: systematic-debugging
description: 4-phase root cause debugging: understand bugs before fixing.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Debugging, RootCause, Engineering, Testing, ProblemSolving]
---

# 4-Phase Root Cause Debugging (Ibra X 3.1)

Metodologi eliminasi bug secara deterministik tanpa tebak-tebakan kode (*guess-and-check*).

## 1. Fase 1: Observasi Perilaku & Formulasi Hipotesis
- Catat perilaku nyata vs perilaku yang diharapkan (*expected vs actual*).
- Susun maksimal 2 hipotesis terkuat mengenai komponen mana yang gagal.

## 2. Fase 2: Isolasi Komponen (Divide and Conquer)
- Nonaktifkan middleware atau modul pihak ketiga untuk memastikan apakah bug berasal dari logika internal atau integrasi eksternal.
- Cetak nilai variabel sebelum dan sesudah operasi kritis.

## 3. Fase 3: Perbaikan Tepat Sasaran
- Modifikasi logika pada tingkat akar masalah, bukan sekadar menambal gejala permukaan (misal: menambahkan `try/catch` kosong tanpa penanganan).

## 4. Fase 4: Validasi & Dokumentasi
- Jalankan seluruh rangkaian test suite untuk memastikan perubahan tidak memicu *side-effect* tak terduga.
