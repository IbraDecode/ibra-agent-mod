---
name: vps-hardening
description: Audit dan automasi pengamanan VPS Linux (UFW, SSH key-only, Fail2ban, kernel sysctl tuning, dan isolasi proses).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [Linux, VPS, Hardening, Security, Sysctl, UFW, SSH]
---

# VPS Linux Production Hardening Protocol (Ibra X 3.1)

Langkah pengamanan fundamental pada server Linux VPS sebelum dialokasikan untuk beban kerja produksi.

## 1. Pengamanan Layanan SSH (`/etc/ssh/sshd_config.d/99-hardened.conf`)

- Nonaktifkan login berbasis kata sandi (wajib SSH Public Key):
  ```ini
  PasswordAuthentication no
  PermitRootLogin prohibit-password
  PubkeyAuthentication yes
  KbdInteractiveAuthentication no
  X11Forwarding no
  MaxAuthTries 3
  ```
- Restart daemon SSH dengan aman:
  ```bash
  sshd -t && systemctl reload ssh
  ```

## 2. Tuning Kernel Parameter (`/etc/sysctl.d/99-security.conf`)

Mitigasi serangan spoofing IP dan ICMP redirects:
```ini
# Abaikan ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Cegah IP Spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Tolak ICMP Redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Lindungi terhadap TCP SYN Flood
net.ipv4.tcp_syncookies = 1
```
Aktifkan konfigurasi via `sysctl --system`.
