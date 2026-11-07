---
name: code-doctor
description: Prosedur sistematis untuk investigasi bug, analisis log error, penelusuran stack trace, dan pencegahan regresi.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Debugging, Troubleshooting, CrashAnalysis, CodeDoctor, QualityAssurance]
---

# Code Doctor & Systematic Diagnostics (Ibra X 3.1)

Protokol investigasi mandiri untuk mendiagnosis kerusakan sistem, crash tak terduga, dan perlambatan runtime.

## 1. Siklus Diagnosis 4 Langkah

1. **Reproduksi Minimum (Minimal Reproducible Case)**:
   Isolasi input atau parameter pemicu error hingga menjadi kasus uji paling sederhana.
2. **Inspeksi Stack Trace & Log**:
   Baca pesan kesalahan dari baris terdalam (*innermost frame*) ke baris terluar untuk menemukan sumber asli kegagalan (*root cause*).
3. **Analisis Diferensial (Git Bisect)**:
   Jika error merupakan regresi baru, lacak commit pertama yang menyebabkan error:
   ```bash
   git bisect start
   git bisect bad HEAD
   git bisect good v3.1.0
   git bisect run pytest
   ```
4. **Verifikasi Solusi & Anti-Regresi**:
   Tulis unit test baru yang menguji kondisi tepi (*edge case*) sebelum menutup investigasi.
