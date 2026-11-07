---
name: performance-profiler
description: Panduan optimasi performa sistem, efisiensi query basis data, kompleksitas algoritma (Big-O), dan manajemen memori.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Performance, Profiling, Optimization, Memory, Big-O, High-Throughput]
---

# Performance & Optimization Profiler (Ibra X 3.1)

Metodologi sistematis untuk mengidentifikasi *bottleneck* performa, mengoptimalkan throughput, dan memangkas penggunaan CPU/memori.

## 1. Analisis Kompleksitas Algoritma & Struktur Data

- **Hindari $O(N^2)$ Loops**: Ganti loop sarang (*nested loops*) dengan `Map` atau `Set` berbasis *hash lookup* untuk mencapai kompleksitas $O(1)$ amortized:
  ```typescript
  // ❌ $O(N * M)$ - Lambat pada dataset besar
  const matched = items.filter(item => allowedIds.includes(item.id));

  // ✅ $O(N + M)$ - Cepat & efisien memori
  const allowedSet = new Set(allowedIds);
  const matched = items.filter(item => allowedSet.has(item.id));
  ```

## 2. Profiling CPU & Deteksi Memory Leak (Node.js & Python)

```bash
# Profiling Node.js menggunakan Chrome DevTools Protocol
node --cpu-prof app.js

# Profiling alokasi memori Python menggunakan tracemalloc
python3 -m cProfile -s tottime app.py | head -n 25
```

## 3. Optimasi Basis Data & Indeksasi
- Tambahkan composite index pada kolom yang sering di-*query* bersamaan dalam klausa `WHERE` dan `ORDER BY`.
- Hindari penggunaan `SELECT *`; ambil hanya field yang benar-benar dikonsumsi oleh view.
