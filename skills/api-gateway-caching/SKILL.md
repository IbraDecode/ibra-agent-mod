---
name: api-gateway-caching
description: Arsitektur caching performa tinggi dan mitigasi beban lonjakan (Redis cache-aside, pencegahan cache stampede, sliding window rate-limiting).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Architecture, Caching, Redis, Rate Limiting, Performance, High Concurrency]
---

# High-Concurrency Caching & Rate Limiting (Ibra X 3.1)

Pola arsitektur standar untuk menangani lonjakan lalu lintas ekstrem (*traffic spikes*), meminimalkan beban basis data, dan melindungi API melalui pembatasan kuota adaptif.

## 1. Pola Cache-Aside dengan Proteksi Mutex (Anti Cache-Stampede)

Cegah ribuan request membombardir database saat kunci cache kadaluwarsa (*dog-piling effect*):

```typescript
// Implementasi Cache-Aside dengan Redis Distributed Lock
async function getCachedData<T>(
  redis: RedisClient,
  key: string,
  ttlSeconds: number,
  fetchFn: () => Promise<T>
): Promise<T> {
  // 1. Cek nilai di cache
  const cached = await redis.get(key);
  if (cached) {
    return JSON.parse(cached) as T;
  }

  // 2. Kunci mutex untuk request pertama yang memperbarui cache
  const lockKey = `lock:${key}`;
  const acquiredLock = await redis.set(lockKey, "1", "NX", "EX", 5);

  if (acquiredLock) {
    try {
      // Ambil data asli dari database
      const data = await fetchFn();
      // Simpan dengan jitter TTL acak untuk mencegah sinkronisasi kadaluwarsa
      const jitter = Math.floor(Math.random() * 10);
      await redis.set(key, JSON.stringify(data), "EX", ttlSeconds + jitter);
      return data;
    } finally {
      await redis.del(lockKey);
    }
  } else {
    // Tunggu sejenak dan coba ambil dari cache kembali
    await new Promise((resolve) => setTimeout(resolve, 50));
    return getCachedData(redis, key, ttlSeconds, fetchFn);
  }
}
```

## 2. Sliding Window Rate Limiting (Redis Sorted Sets)

Menghindari lonjakan permintaan tepat di perbatasan jendela waktu (*edge burst*) yang sering lolos pada algoritma fixed-window:

```python
import time

def is_rate_limited(redis_client, client_ip: str, limit: int = 100, window_sec: int = 60) -> bool:
    """Membatasi request menggunakan sliding-window log berbasis Redis Sorted Set."""
    now = time.time()
    clear_before = now - window_sec
    key = f"ratelimit:{client_ip}"

    pipeline = redis_client.pipeline()
    # Hapus entri request yang sudah di luar rentang jendela waktu
    pipeline.zremrangebyscore(key, 0, clear_before)
    # Catat timestamp request saat ini
    pipeline.zadd(key, {str(now): now})
    # Hitung jumlah request aktif dalam jendela waktu
    pipeline.zcard(key)
    # Atur masa kadaluwarsa kunci Redis
    pipeline.expire(key, window_sec)
    
    _, _, current_count, _ = pipeline.execute()
    return current_count > limit
```

## 3. Strategi HTTP Caching Headers

- **`Cache-Control: public, max-age=300, stale-while-revalidate=60`**: Browser dan CDN menyajikan cache lama selama 60 detik sembari memperbarui data di latar belakang.
- **`ETag` & `If-None-Match`**: Mengembalikan status `304 Not Modified` tanpa mengirim payload data ulang jika konten tidak berubah.
