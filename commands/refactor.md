---
description: Analisis arsitektur kode dan buat rencana refactoring modular mendalam (Clean Code, SOLID, decoupling).
---

Sebagai agen **Ibra X 3.1 / 3.2**, lakukan audit struktur kode pada direktori kerja saat ini dan berikan rekomendasi refactoring tingkat tinggi:

1. **Analisis Smell & Antipattern**:
   - Deteksi fungsi berukuran raksasa (*God functions / classes*).
   - Identifikasi keterikatan ketat (*tight coupling*) antarmodul.
   - Temukan logika duplikat (*DRY violations*) dan *magic numbers/strings*.

2. **Penerapan Prinsip SOLID & Clean Architecture**:
   - Pisahkan logika bisnis inti dari implementasi framework/database (Hexagonal / Clean Architecture).
   - Rancang antarmuka (*interfaces/contracts*) untuk mempermudah unit testing dan mocking.

3. **Rencana Migrasi Bertahap (Non-Breaking)**:
   - Sajikan contoh kode *Before & After* konkret.
   - Pastikan API eksternal dan test suite tetap kompatibel selama proses refactoring.
