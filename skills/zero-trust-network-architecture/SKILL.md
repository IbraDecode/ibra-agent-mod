---
name: zero-trust-network-architecture
description: Implementasi arsitektur jaringan Zero-Trust (mTLS antarlayanan, enkripsi WireGuard mesh, filtering egress, dan autentikasi berbasis identitas).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Security, Zero-Trust, Network, WireGuard, mTLS, Architecture, Encryption]
---

# Zero-Trust Network Architecture (ZTNA) Protocol (Ibra X 3.1)

Prinsip *Never Trust, Always Verify* pada level jaringan infrastruktur cloud dan antarkomponen layanan.

## 1. Mutual TLS (mTLS) Enkripsi Antarlayanan

Setiap koneksi HTTP antarmikroservis wajib memverifikasi sertifikat klien dan server:

```nginx
# Konfigurasi NGINX mTLS Termination
server {
    listen 8443 ssl;
    server_name internal.service.local;

    ssl_certificate         /etc/ssl/server.crt;
    ssl_certificate_key     /etc/ssl/server.key;

    # Verifikasi Sertifikat Klien
    ssl_client_certificate  /etc/ssl/ca-internal.crt;
    ssl_verify_client       on;
    ssl_verify_depth        2;

    ssl_protocols           TLSv1.3;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header X-Client-DN $ssl_client_s_dn;
    }
}
```

## 2. WireGuard Mesh Tunnel Antar-Node VPS (`/etc/wireguard/wg0.conf`)

Enkripsi seluruh lalu lintas antarnode dengan overhead latensi minimal:

```ini
[Interface]
Address = 10.100.0.1/24
PrivateKey = CLIENT_PRIVATE_KEY
ListenPort = 51820

# Node Peer Target
[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 10.100.0.2/32
Endpoint = 203.0.113.50:51820
PersistentKeepalive = 25
```

## 3. Strict Egress Filtering (Mencegah C2 & Data Exfiltration)

Tolak seluruh koneksi keluar kecuali ke host yang telah diizinkan secara eksplisit:

```bash
# Batasi egress server hanya ke port DNS (53), HTTP/HTTPS (80/443), dan NTP (123)
sudo iptables -P OUTPUT DROP
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
```
