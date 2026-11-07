---
name: docker-container-security
description: Protokol audit keamanan kontainer Docker (non-root user, read-only rootfs, capabilities drop, seccomp, isolasi jaringan, dan scan image).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Docker, Security, Containers, DevSecOps, Hardening, Isolation]
---

# Docker Container Security & Hardening (Ibra X 3.1)

Pedoman komprehensif untuk mengamankan kontainer Docker dan file `docker-compose.yml` guna mencegah eskalasi hak akses (*container escape*), modifikasi biner berbahaya, dan kebocoran sumber daya.

## 1. Prinsip Least Privilege pada Dockerfile

Jangan pernah menjalankan proses kontainer sebagai `root`:

```dockerfile
# Contoh Dockerfile yang diamankan
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app

# Buat grup dan user unprivileged
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Salin artefak dengan izin kepemilikan terbatas
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules

# Beralih ke pengguna non-root
USER appuser

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## 2. Hardening pada `docker-compose.yml`

```yaml
version: '3.8'

services:
  api:
    image: my-app:latest
    user: "10001:10001"
    read_only: true              # Filesystem root kontainer tidak dapat diubah (immutable)
    security_opt:
      - no-new-privileges:true   # Cegah proses anak mendapatkan izin lebih tinggi
    cap_drop:
      - ALL                      # Hapus seluruh izin Linux capabilities default
    cap_add:
      - NET_BIND_SERVICE         # Tambahkan hanya izin yang mutlak dibutuhkan
    tmpfs:
      - /tmp:rw,noexec,nosuid    # Mount direktori tulis sementara tanpa hak eksekusi biner
    deploy:
      resources:
        limits:
          cpus: '1.0'            # Batasi CPU untuk mencegah DoS
          memory: 512M           # Batasi RAM untuk mencegah OOM pada host
    restart: on-failure:5
```

## 3. Audit Runtime & Pemindaian Celah Image

```bash
# Periksa apakah ada kontainer yang berjalan dengan mode privileged berbahaya
docker ps --quiet | xargs docker inspect --format '{{.Name}}: Privileged={{.HostConfig.Privileged}}'

# Audit kontainer yang mengekspos port ke 0.0.0.0 secara tidak sengaja
docker ps --format "table {{.Names}}\t{{.Ports}}"
```
