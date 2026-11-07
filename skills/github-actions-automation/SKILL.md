---
name: github-actions-automation
description: Blueprint otomatisasi alur kerja CI/CD GitHub Actions (multi-arch Docker builds, release automation, PR gates, security scan).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [DevOps, CI/CD, GitHub Actions, Docker, Automation, Releases]
---

# GitHub Actions Automation Suite (Ibra X 3.1)

Kumpulan template alur kerja CI/CD berstandar industri untuk mengotomasi pengujian, rilis, kontainerisasi, dan audit kode pada repositori GitHub.

## 1. Multi-Arch Docker Buildx & Push (`.github/workflows/docker-publish.yml`)

Membangun image kontainer untuk arsitektur `linux/amd64` dan `linux/arm64` secara paralel dan mempublikasikannya ke GitHub Container Registry (GHCR):

```yaml
name: Build & Push Docker Image

on:
  push:
    tags: ['v*.*.*']
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  docker:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log into registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract Docker metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=sha,format=short

      - name: Build and push image
        uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## 2. Automated PR Quality Gate & Test (`.github/workflows/pr-gate.yml`)

Memverifikasi kode pull-request sebelum diizinkan untuk di-merge:

```yaml
name: PR Quality Gate

on:
  pull_request:
    branches: [main, dev]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Runtime
        uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm test -- --coverage
```

## 3. Otomasi GitHub CLI (`gh`) di Terminal

Gunakan GitHub CLI lokal untuk memicu dan memantau workflow secara instan:
```bash
# Pantau workflow langsung di terminal
gh run list --limit 5
gh run watch

# Pemicu alur kerja manual (workflow_dispatch)
gh workflow run docker-publish.yml -f ref=main

# Melihat log error langkah yang gagal
gh run view --log-failed
```
