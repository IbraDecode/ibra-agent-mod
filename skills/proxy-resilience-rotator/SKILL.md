---
name: proxy-resilience-rotator
description: High-concurrency proxy pool management, health-check scoring, TLS fingerprint (JA3/JA4) evasion, and residential failover
---

# Proxy Resilience & Rotation Skill

Infrastruktur dan metodologi pengelolaan proxy tingkat lanjut untuk automasi dan web farming:

## 1. Arsitektur Proxy Pool
Gunakan arsitektur rotasi bertingkat:
- **L1 (Datacenter / Cheap)**: Digunakan untuk discovery awal, fetch statis, dan non-WAF endpoints.
- **L2 (Residential Rotating)**: Digunakan untuk endpoint otentikasi, pendaftaran akun, dan verifikasi OTP.
- **L3 (Mobile 4G/5G)**: Cadangan darurat untuk target dengan proteksi ketat (Cloudflare Under Attack / Datadome).

## 2. Health-Check & Auto-Scoring
Skrip pengujian berkala untuk memvalidasi:
1. **Latensi**: Response time di bawah 1500ms.
2. **Anonimitas**: Tidak membocorkan header `X-Forwarded-For` atau IP asli.
3. **Status Ban**: Uji langsung terhadap target domain (HTTP 200 vs 403/429).

## 3. Evasion Sidik Jari TLS (JA3/JA4)
- Selalu kombinasikan proxy dengan `curl_cffi` atau impersonate browser (Chrome 120+, Safari) agar signature TLS handshake cocok dengan browser nyata:
```python
from curl_cffi import requests
response = requests.get(
    "https://target.com/api",
    impersonate="chrome124",
    proxies={"https": "http://user:pass@proxy.provider.com:8000"}
)
```
