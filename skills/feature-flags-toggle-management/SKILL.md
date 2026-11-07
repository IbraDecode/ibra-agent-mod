---
name: feature-flags-toggle-management
description: Arsitektur Feature Flagging dinamis (Trunk-Based Development, rollout bertahap canary, circuit breaker toggles, dan zero-downtime deprecation).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Architecture, FeatureFlags, DevOps, CI/CD, Canary, TrunkBasedDevelopment]
---

# Dynamic Feature Flags & Canary Rollout Architecture (Ibra X 3.1)

Pola pemisahan waktu deployment kode dari waktu aktivasi fitur bisnis (*decoupling release from deployment*) untuk menjamin stabilitas rilis produksi.

## 1. Implementasi Evaluasi Flag Berbasis Persentase Pengguna (Hashing Konsisten)

Memastikan pengguna yang sama selalu mendapatkan perlakuan yang sama tanpa fluktuasi (*sticky evaluation*):

```python
import hashlib

def is_feature_enabled(feature_name: str, user_id: str, rollout_percentage: int) -> bool:
    \"\"\"Menghitung konsistensi bucket pengguna (0-99) menggunakan MD5 hash.\"\"\"
    if rollout_percentage <= 0:
        return False
    if rollout_percentage >= 100:
        return True

    key = f"{feature_name}:{user_id}".encode("utf-8")
    hash_val = int(hashlib.md5(key).hexdigest()[:8], 16)
    user_bucket = hash_val % 100
    return user_bucket < rollout_percentage

# Contoh: 20% rollout canary
user_id = "user_98124"
if is_feature_enabled("new_checkout_flow", user_id, 20):
    print("Pengguna masuk dalam kelompok uji coba Canary (Fitur Baru Aktif)")
else:
    print("Pengguna menggunakan alur checkout standar (Stabil)")
```

## 2. Pola Circuit Breaker Toggle

Gunakan flag sebagai saklar darurat (*kill switch*) untuk memutus integrasi pihak ketiga yang mengalami kegagalan tanpa perlu melakukan redeployment darurat.
