---
description: Uji komparasi latensi dan throughput multi-model AI secara paralel (Ibra Prime, Claude Sonnet, Opus Thinking, dan 120B Fast).
---

Sebagai agen **Ibra X 3.1 / 3.2**, lakukan pengujian latensi inferensi komparatif ke seluruh model router AI:

1. **Pengujian Model Utama**:
   - `9router/is/ibra` (Ibra Prime)
   - `9router/is/ag/claude-sonnet-4-6` (Sonnet Coding & Vision)
   - `9router/is/ag/claude-opus-4-6-thinking` (Opus Thinking Explorer)
   - `9router/ag/gpt-oss-120b-medium` (Ultra Fast 120B)

2. **Parameter Pengukuran**:
   - Waktu ke token pertama (*Time To First Token - TTFT*).
   - Total waktu eksekusi request (*Wall-clock latency*).
   - Status respons HTTP dan ketersediaan kuota token.

3. **Output Tabel Ringkasan**:
   Sajikan hasil perbandingan dalam bentuk tabel Markdown yang rapi disertai evaluasi kecepatan jaringan.
