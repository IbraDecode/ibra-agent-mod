---
name: api-load-testing
description: Skrip pengujian beban API berkecepatan tinggi, stres testing konkuren, serta pengukuran metrik latensi p50/p95/p99 dan throughput RPS.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Testing, Performance, API, Load Testing, Benchmark, Concurrency]
---

# API Load Testing & Concurrency Benchmark (Ibra X 3.1)

Alat pengujian beban endpoint REST/GraphQL berkecepatan tinggi tanpa dependensi eksternal yang rumit, dibangun menggunakan Python `asyncio` dan `urllib`.

## 1. Quick Async Load Tester (Python)

Simpan skrip berikut sebagai `load_test.py`:

```python
#!/usr/bin/env python3
import asyncio, time, urllib.request, json, statistics, sys

async def worker(url, headers, duration_sec, results):
    end_time = time.time() + duration_sec
    while time.time() < end_time:
        t0 = time.time()
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=10) as resp:
                status = resp.status
                resp.read()
            elapsed = time.time() - t0
            results.append((elapsed, status, None))
        except Exception as e:
            elapsed = time.time() - t0
            results.append((elapsed, 0, str(e)))
        await asyncio.sleep(0.001)

async def run_benchmark(url, concurrency=20, duration=10, headers=None):
    if headers is None:
        headers = {"User-Agent": "Ibra-LoadTester/3.1"}
    print(f"🚀 Memulai benchmark target: {url}")
    print(f"   Konkurensi: {concurrency} workers | Durasi: {duration} detik")
    results = []
    tasks = [worker(url, headers, duration, results) for _ in range(concurrency)]
    start = time.time()
    await asyncio.gather(*tasks)
    total_time = time.time() - start

    latencies = [r[0] * 1000 for r in results if r[1] == 200]
    errors = [r for r in results if r[1] != 200]
    total_reqs = len(results)
    rps = total_reqs / total_time if total_time > 0 else 0

    print("\n" + "=" * 50)
    print("📊 HASIL PENGUJIAN BEBAN:")
    print("=" * 50)
    print(f"Total Request        : {total_reqs}")
    print(f"Request Berhasil (200): {len(latencies)}")
    print(f"Request Gagal/Error  : {len(errors)}")
    print(f"Throughput Rata-rata : {rps:.1f} Req/Sec")

    if latencies:
        latencies.sort()
        p50 = statistics.median(latencies)
        p90 = latencies[int(len(latencies) * 0.90)]
        p95 = latencies[int(len(latencies) * 0.95)]
        p99 = latencies[int(len(latencies) * 0.99)]
        print(f"Latensi Rata-rata    : {statistics.mean(latencies):.2f} ms")
        print(f"Latensi Min / Max    : {min(latencies):.2f} ms / {max(latencies):.2f} ms")
        print(f"Latensi P50 (Median) : {p50:.2f} ms")
        print(f"Latensi P90          : {p90:.2f} ms")
        print(f"Latensi P95          : {p95:.2f} ms")
        print(f"Latensi P99          : {p99:.2f} ms")
    print("=" * 50)

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "https://httpbin.org/get"
    conc = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    dur = int(sys.argv[3]) if len(sys.argv) > 3 else 5
    asyncio.run(run_benchmark(target, conc, dur))
```

## 2. Cara Menjalankan

```bash
# Uji target dengan 20 koneksi konkuren selama 10 detik
python3 load_test.py https://api.anda.com/v1/health 20 10
```

## 3. Metrik Utama untuk Evaluasi

- **P95 Latency**: 95% pengguna merasakan latensi di bawah nilai ini. Harus berada di bawah 200ms untuk API real-time.
- **P99 Latency**: Indikator penumpukan antrean koneksi (*cold-start* atau *tail latency*).
- **Error Rate**: Harus 0.00% pada beban puncak. Jika muncul status `429` (Too Many Requests) atau `502/504` (Bad Gateway), berarti server membutuhkan auto-scaling atau reverse proxy tuning.
