# IBRA X 3.1 — MESIN EKSEKUSI OTONOM

<p align="center">
  <b>Profil Eksekusi Mandiri & Paket 179+ Keahlian untuk OpenCode & Hermes Agent</b><br/>
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
- **179+ Keahlian (Skills) Terpasang**: Mencakup audit keamanan, reverse engineering, bypass anti-bot/WAF, metodologi deep modules, hingga orkestrasi subagent.
- **Integrasi Penuh OpenCode & Hermes**: Berjalan mulus di OpenCode V2 dan Hermes Agent.

---

## Panduan Instalasi

### 1. Instalasi Instan (One-Liner via Curl)

Cukup jalankan satu baris perintah ini pada terminal server Anda:

```bash
curl -fsSL https://raw.githubusercontent.com/IbraDecode/ibra-agent-mod/main/install.sh | bash
```

### 2. Instalasi Manual / Dari Clone Repositori

```bash
git clone https://github.com/IbraDecode/ibra-agent-mod.git
cd ibra-agent-mod
bash install.sh
```

### 3. Instalasi Khusus per Agent

```bash
# Untuk OpenCode saja:
bash install.sh opencode

# Untuk Hermes Agent saja:
bash install.sh hermes
```

---

## Fitur OpenCode

Saat terpasang pada OpenCode (`~/.config/opencode`):
- **179+ Skills Aktif**: Terdeteksi secara global dan siap digunakan oleh seluruh agen.
- **Agen `ibra-x`**: Agen eksekusi otonom berkecepatan tinggi:
  ```bash
  opencode run --agent ibra-x "Tugas Anda"
  ```
- **11 Perintah Kustom Pintar**:
  - `/status`: Diagnostik kesehatan server, Docker, RAM, dan koneksi router API.
  - `/arsitektur`: Analisis arsitektur sistem, modularitas, dan rekomendasi refaktorisasi.
  - `/keamanan`: Audit celah keamanan mendalam (OWASP, secret leaks, permission issues).
  - `/benchmark`: Uji latensi router model AI dan waktu respons secara real-time.
  - `/tinjau`: Audit diff Git untuk mencari celah keamanan & regresi logika.
  - `/perbaiki <masalah>`: Analisis dan perbaikan kode langsung.
  - `/komit`: Formulasi pesan Git otomatis berstandar *Conventional Commits*.
  - `/uji <fitur>`: Perancangan unit test komprehensif (*happy path & boundary*).
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
