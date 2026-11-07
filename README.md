# IBRA X 3.1 — MESIN EKSEKUSI OTONOM

<p align="center">
  <b>Profil Eksekusi Mandiri & Paket 187+ Keahlian untuk OpenCode & Hermes Agent</b><br/>
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
- **187+ Keahlian (Skills) Terpasang**: Mencakup audit keamanan, reverse engineering, bypass anti-bot/WAF, metodologi deep modules, hingga orkestrasi subagent.
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
- **187+ Skills Aktif**: Terdeteksi secara global dan siap digunakan oleh seluruh agen.
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

## 🛠️ Ibra Command Center CLI (`ibra`)

Setelah instalasi, perintah global `ibra` tersedia langsung di terminal Anda:

```bash
# Diagnostik menyeluruh integritas sistem, MCP server & router
ibra doctor

# Jalankan tugas otonom dengan agen 'ibra-x' (Claude Sonnet 4.6)
ibra run "Buat skrip backup otomatis database ke S3"

# Eksekusi tugas kilat dengan model Ultra Fast 120B
ibra fast "Tulis fungsi debounce TypeScript"

# Eksplorasi mendalam & audit logika dengan Opus Thinking
ibra explore "Analisis celah keamanan pada modul auth"

# Pemeriksaan kesehatan & latensi real-time
ibra status
ibra benchmark

# Audit arsitektur & keamanan direktori kerja saat ini
ibra arsitektur
ibra keamanan

# Scaffold template proyek baru (REST API, Cloudflare Worker, Bot)
ibra init api

# Statistik komprehensif keahlian, perintah & sistem
ibra stats

# Kirim notifikasi alert via Telegram / Discord / Webhook
ibra notify "Tugas kompilasi produksi selesai" "Job Status"

# Perbarui mod langsung ke versi terbaru dari GitHub
ibra update
```

---

## 🔌 Model Context Protocol (MCP) Server: `ibra-core`

Mod ini menyertakan MCP server bawaan berbasis Python murni (`mcp/ibra_mcp.py`) yang terhubung langsung ke OpenCode:

- **`ibra_system_diagnostics`**: Metrik instan RAM, CPU load, kapasitas disk, uptime, dan status engine Docker.
- **`ibra_port_checker`**: Uji konektivitas port TCP target (network socket probe).
- **`ibra_http_inspect`**: Inspeksi mendalam status HTTP, header, latensi transfer, dan SSL.
- **`ibra_process_monitor`**: Memantau top proses pemakan memori/CPU atau filter nama proses.
- **`ibra_security_quick_audit`**: Audit izin file sensitif host (`/etc/shadow`, `/root/.ssh`), listening ports, dan firewall.

---

## 🐳 Docker Sandbox Deployment

Untuk menjalankan agen di lingkungan kontainer terisolasi yang aman:

```bash
cd ibra-agent-mod/docker
docker compose up -d
docker compose exec ibra-agent ibra menu
```

---

## Struktur Proyek

```text
ibra-agent-mod/
├── bin/                        # Binary CLI terminal (ibra, ibra-notify)
├── docker/                     # Dockerfile & docker-compose sandbox
├── mcp/                        # Server MCP mandiri (ibra_mcp.py)
├── commands/                   # 11 Perintah kustom OpenCode (/status, /keamanan, dll.)
├── skills/                     # Pustaka 187+ keahlian teknis modular
├── install.sh                  # Installer universal (One-liner curl ready)
├── install-opencode.sh         # Installer khusus OpenCode
├── SOUL.md                     # Inti profil identitas dan aturan eksekusi Ibra X 3.1
├── opencode.example.json       # Template konfigurasi OpenCode + MCP
├── config.example.yaml         # Template konfigurasi Hermes Agent
└── README.md                   # Dokumentasi resmi Ibra X 3.1
```

## Lisensi

MIT License — Bebas digunakan, diadaptasi, dan dikembangkan.

*Ibra X 3.1 Prime · Didukung oleh Ibra AI*
