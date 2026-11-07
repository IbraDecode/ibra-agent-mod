---
name: api-router-proxy-cloning
description: Clone API routers with multi-upstream auto-detection.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Router, Proxy, ReverseProxy, Upstream, HighAvailability]
---

# Multi-Upstream API Router & Reverse Proxy Cloning (Ibra X 3.1)

Pola perancangan proxy perutean lalu lintas API dengan kemampuan *failover* multi-upstream otomatis dan normalisasi format respons.

## 1. Arsitektur Perutean Cerdas (Smart Upstream Routing)

```python
import urllib.request, time

UPSTREAMS = [
    {"url": "https://api-primary.service.internal", "healthy": True, "fails": 0},
    {"url": "https://api-secondary.service.internal", "healthy": True, "fails": 0}
]

def forward_request_with_fallback(path: str, headers: dict, body: bytes = None):
    for node in UPSTREAMS:
        if not node["healthy"] and node["fails"] >= 3:
            continue
        try:
            req = urllib.request.Request(f"{node['url']}{path}", data=body, headers=headers)
            with urllib.request.urlopen(req, timeout=3) as resp:
                node["fails"] = 0
                return resp.read(), resp.status
        except Exception:
            node["fails"] += 1
            if node["fails"] >= 3:
                node["healthy"] = False
    raise RuntimeError("Semua upstream gateway tidak merespons.")
```
