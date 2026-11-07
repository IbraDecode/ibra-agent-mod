---
name: system-telemetry-monitoring
description: Monitoring metrik node Linux, Prometheus node_exporter setup, Grafana dashboard provisioning, dan alert thresholds.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [Monitoring, Prometheus, Grafana, Telemetry, Linux, Metrics]
---

# System Telemetry & Node Monitoring (Ibra X 3.1)

Standar pengumpulan metrik sistem tingkat kernel dan perangkat keras untuk mendeteksi degradasi performa sebelum berdampak pada ketersediaan layanan.

## 1. Setup Node Exporter Ringan via Docker

```yaml
version: '3.8'

services:
  node-exporter:
    image: prom/node-exporter:v1.7.0
    container_name: ibra-node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - "127.0.0.1:9100:9100"
```

## 2. Metrik Kritis untuk Alerting
- **Penggunaan CPU**: Rata-rata CPU `> 85%` selama 5 menit berturut-turut.
- **Kapasitas Disk**: Sisa ruang disk root `< 15%`.
- **Memory Saturation**: Memori swap mulai digunakan secara intensif (`swap_in/swap_out` meningkat tajam).
