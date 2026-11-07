---
name: vps-hardening
description: Audit dan automasi pengamanan VPS Linux (UFW, SSH key-only, Fail2ban, kernel sysctl tuning, dan isolasi proses).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [Security, VPS, Linux, Sysadmin, Hardening, Firewall, SSH]
---

# VPS Hardening & Security Protocol (Ibra X 3.1)

Protokol pengamanan komprehensif untuk VPS Linux Ubuntu/Debian/RHEL/CentOS guna mencegah serangan brute-force, eksploitasi port terbuka, dan serangan DoS tingkat jaringan.

## 1. SSH Hardening (`/etc/ssh/sshd_config`)

Terapkan aturan ketat untuk menolak login kata sandi dan brute force:

```bash
# Nonaktifkan login kata sandi & batasi otentikasi hanya via SSH Key
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?MaxAuthTries .*/MaxAuthTries 3/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?X11Forwarding .*/X11Forwarding no/' /etc/ssh/sshd_config

# Reload ssh service dengan aman (tanpa memutus koneksi aktif)
sudo systemctl reload sshd || sudo systemctl reload ssh
```

## 2. Firewall Strict Configuration (UFW / iptables)

```bash
# Set default policy: tolak semua inbound, izinkan outbound
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Izinkan port esensial
sudo ufw allow 22/tcp comment 'SSH Port'
sudo ufw allow 80/tcp comment 'HTTP Web'
sudo ufw allow 443/tcp comment 'HTTPS Web'

# Aktifkan firewall
sudo ufw --force enable
sudo ufw status verbose
```

## 3. Kernel Network Hardening (`/etc/sysctl.d/99-security.conf`)

Terapkan proteksi kernel terhadap SYN Flood, IP Spoofing, dan ICMP Redirects:

```ini
# /etc/sysctl.d/99-security.conf
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv6.conf.all.disable_ipv6 = 1
```

Aktifkan konfigurasi seketika:
```bash
sudo sysctl --system
```

## 4. Fail2ban Protection (Anti-Brute Force)

```bash
sudo apt update && sudo apt install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban
sudo fail2ban-client status sshd
```

## 5. Audit Port & Layanan Terbuka

Periksa apakah ada proses berbahaya yang mendengarkan interface publik:
```bash
ss -tulpn
```
Pastikan database lokal (seperti Redis `6379`, MySQL `3306`, Postgres `5432`) hanya terikat pada `127.0.0.1` (*localhost*), bukan `0.0.0.0`.
