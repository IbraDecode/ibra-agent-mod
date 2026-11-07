---
name: proxy-resilience-rotator
description: High-concurrency proxy pool management, health-check scoring, TLS fingerprint (JA3/JA4) evasion, and residential failover.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Networking, Proxy, Scraping, Evasion, Resilience, Concurrency, Architecture]
---

# Proxy Resilience & Dynamic Rotation Engine (Ibra X 3.1)

Pola desain rotasi proxy berdaya tahan tinggi (*resilient proxy rotation*) untuk operasi automasi jaringan skala besar yang tahan terhadap IP ban, *rate limiting*, dan deteksi *fingerprint* TLS.

## 1. Arsitektur Proxy Pool dengan Health-Scoring

Setiap proxy dinilai berdasarkan latensi dan tingkat keberhasilan (*success rate*). Proxy yang gagal berturut-turut dikarantina secara adaptif:

```python
import time, random

class ResilientProxyPool:
    def __init__(self, proxy_list):
        # Struktur: { "proxy_url": {"score": 100, "fails": 0, "quarantine_until": 0} }
        self.pool = {
            p: {"score": 100, "fails": 0, "quarantine_until": 0}
            for p in proxy_list
        }

    def get_best_proxy(self) -> str:
        now = time.time()
        # Ambil proxy yang tidak sedang dikarantina
        available = [
            p for p, stat in self.pool.items()
            if stat["quarantine_until"] <= now
        ]
        if not available:
            # Jika semua dikarantina, gunakan proxy dengan skor tertinggi
            available = list(self.pool.keys())
        
        # Weighted random berdasarkan skor keandalan
        weights = [max(1, self.pool[p]["score"]) for p in available]
        return random.choices(available, weights=weights, k=1)[0]

    def report_result(self, proxy: str, success: bool, latency_ms: float = 0):
        stat = self.pool[proxy]
        if success:
            stat["score"] = min(100, stat["score"] + 5)
            stat["fails"] = 0
        else:
            stat["fails"] += 1
            stat["score"] = max(0, stat["score"] - 25)
            # Karantina eksponensial: 30s, 60s, 120s...
            stat["quarantine_until"] = time.time() + (30 * (2 ** (stat["fails"] - 1)))
```

## 2. Penghindaran Sidik Jari TLS (JA3/JA4 Evasion)

Mencegah deteksi WAF (Cloudflare/Akamai) melalui randomisasi *cipher suites* dan ekstensi TLS:

```python
import ssl
import urllib.request

def create_stealth_ssl_context() -> ssl.SSLContext:
    ctx = ssl.create_default_context()
    # Gunakan cipher modern yang umum digunakan oleh peramban Chrome versi stabil
    CIPHERS = (
        "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:"
        "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:"
        "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305"
    )
    ctx.set_ciphers(CIPHERS)
    ctx.minimum_version = ssl.TLSVersion.TLSv1_2
    ctx.maximum_version = ssl.TLSVersion.TLSv1_3
    return ctx
```

## 3. Strategi Failover Bertingkat (Datacenter -> ISP -> Residential)

1. **Tingkat 1 (Datacenter Proxies)**: Cepat dan murah untuk endpoint tanpa proteksi bot ketat.
2. **Tingkat 2 (Static ISP Proxies)**: IP residential statis dengan latensi stabil jika endpoint mulai mengembalikan status `429 Too Many Requests`.
3. **Tingkat 3 (Rotating Residential / 4G Mobile)**: Failover pamungkas ketika menghadapi verifikasi Cloudflare Turnstile atau Akamai Sensor Data.
