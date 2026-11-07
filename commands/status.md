---
description: Cek status kesehatan sistem, koneksi router API, Docker, dan kesiapan agen Ibra X 3.1
model: 9router/is/ag/claude-sonnet-4-6
---

Berikut data diagnostik sistem saat ini:

Konektivitas Router API:
!`curl -o /dev/null -s -w 'HTTP %{http_code} | Latensi: %{time_total}s\n' -H "Authorization: Bearer sk-74719b5a958826c8-wenh6o-7dd6518c" https://app.ibra.ai.id/v1/models`

Status Engine Docker:
!`docker info --format 'Versi: {{.ServerVersion}} | Containers Berjalan: {{.ContainersRunning}} | Total Image: {{.Images}}' 2>/dev/null || echo "Docker nonaktif"`

Beban Sistem & Memori:
!`uptime && free -h | awk '/Mem:/ {print "RAM: " $3 " terpakai dari " $2}'`

Tugas:
Sajikan laporan status kesehatan operasional Ibra X 3.1 dalam bentuk tabel metrik yang rapi, ringkas, dan profesional dalam Bahasa Indonesia.
