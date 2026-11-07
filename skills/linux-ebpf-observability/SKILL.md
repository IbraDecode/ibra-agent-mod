---
name: linux-ebpf-observability
description: Observabilitas kernel Linux modern menggunakan eBPF (Extended Berkeley Packet Filter), inspeksi soket jaringan kprobe/uprobe, dan penelusuran I/O latency.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [Linux, Kernel, eBPF, Observability, Performance, BCC, Tracing]
---

# Linux Kernel Observability with eBPF (Ibra X 3.1)

Metodologi penelusuran perilaku kernel Linux tanpa memuat modul kernel eksternal atau memodifikasi kode sumber (*zero overhead telemetry*).

## 1. Konsep Dasar eBPF (Kprobes & Tracepoints)

eBPF memungkinkan eksekusi bytecode terverifikasi secara aman di dalam ruang kernel Linux saat terjadi pemanggilan sistem (*syscall*):
- **Kprobes / Kretprobes**: Menempel pada fungsi kernel mana pun secara dinamis.
- **Tracepoints**: Titik pengukuran statis yang telah ditentukan sebelumnya oleh kernel.
- **Uprobes**: Menempel pada fungsi di ruang pengguna (*userspace*).

## 2. Inspeksi Latensi Disk I/O via BCC Tools

```bash
# Melacak distribusi latensi operasi baca/tulis blok penyimpanan (biolatency)
sudo biolatency -m 1 10

# Melacak proses yang membuka file baru secara real-time (opensnoop)
sudo opensnoop -T
```

## 3. Monitoring Koneksi TCP Socket (tcptop)

Mengetahui proses mana yang mengonsumsi bandwidth jaringan terbesar tanpa mencemari sistem:
```bash
sudo tcptop -C 5
```
