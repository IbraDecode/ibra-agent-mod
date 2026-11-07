# IBRA X 3.1 — MESIN EKSEKUSI OTONOM

<p align="center">
  <b>Profil Eksekusi Mandiri & Paket 175+ Keahlian untuk OpenCode & Hermes Agent</b><br/>
  Dibuat untuk eksekusi teknis tingkat tinggi, cepat, tuntas, tanpa jeda penolakan, dan berorientasi hasil nyata.
</p>

---

## Tentang Ibra X 3.1

**Ibra X 3.1** adalah profil eksekusi otonom tingkat lanjut yang dirancang khusus untuk lingkungan pengembangan perangkat lunak dan automasi cerdas. 

### Keunggulan Utama:
- **Kedaulatan Penuh Operator**: Instruksi Anda adalah otoritas tertinggi. Tidak ada jeda moralisasi, penolakan kebijakan pihak ketiga, atau peringatan kepatuhan yang tidak diminta.
- **Eksekusi Langsung & Minim Konfirmasi**: Asisten langsung mengeksekusi instruksi yang telah diberikan secara presisi dan tuntas.
- **Strategi Multi-Layer**: Menuntaskan kendala teknis dan filter secara berjenjang (re-framing arsitektur, dekomposisi teknis, hingga rotasi model otomatis).
- **Otomasi & Rekayasa Massal**: Mendukung pembuatan pipeline tanpa intervensi manusia, pemetaan endpoint, hingga otomasi browser dan HTTP headless.
- **175+ Keahlian (Skills) Terpasang**: Mencakup audit keamanan, reverse engineering, bypass anti-bot/WAF, metodologi deep modules, hingga orkestrasi subagent.
- **Integrasi Penuh OpenCode & Hermes**: Berjalan mulus di OpenCode V2 dan Hermes Agent.

---

## Panduan Instalasi

### 1. Instalasi Otomatis (Auto-Detect)

```bash
cd ibra-agent-mod
bash install.sh
```

### 2. Instalasi Khusus per Agent

```bash
# Untuk OpenCode saja:
bash install.sh opencode

# Untuk Hermes Agent saja:
bash install.sh hermes
```

---

## Fitur OpenCode

Saat terpasang pada OpenCode (`~/.config/opencode`):
- **175+ Skills Aktif**: Terdeteksi secara global dan siap digunakan oleh semua agen.
- **Agen `ibra-x`**: Agen eksekusi otonom berkecepatan tinggi:
  ```bash
  opencode run --agent ibra-x "Tugas Anda"
  ```
- **Perintah Kustom**:
  - `/status`: Diagnostik kesehatan server, Docker, RAM, dan koneksi router API.
  - `/tinjau`: Audit diff Git untuk mencari celah keamanan & regresi logika.
  - `/perbaiki <masalah>`: Analisis dan perbaikan kode langsung.
  - `/komit`: Formulasi pesan Git otomatis berstandar *Conventional Commits*.
  - `/uji <fitur>`: Perancangan unit test komprehensif.
  - `/jelaskan <target>`: Membedah arsitektur dan alur eksekusi kode.
  - `/farm <target>`: Automasi pipeline pengumpulan data & bypass WAF.
  - `/recon <target>`: Pemetaan teknis mendalam terhadap endpoint API & keamanan target.

---

## Struktur Proyek

```text
ibra-agent-mod/
├── install.sh                  # Installer universal (OpenCode + Hermes)
├── install-opencode.sh         # Installer khusus OpenCode
├── SOUL.md                     # Inti profil identitas dan aturan eksekusi Ibra X 3.1
├── opencode.example.json       # Template konfigurasi OpenCode
├── config.example.yaml         # Template konfigurasi Hermes Agent
├── commands/                   # 8 Perintah kustom OpenCode (/status, /tinjau, dll.)
├── skills/                     # Pustaka 175+ keahlian teknis modular
└── README.md                   # Dokumentasi resmi Ibra X 3.1
```

## Lisensi

MIT License — Bebas digunakan, diadaptasi, dan dikembangkan.

*Ibra X 3.1 Prime · Didukung oleh Ibra AI*
