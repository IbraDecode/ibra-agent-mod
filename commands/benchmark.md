---
description: Uji benchmark kecepatan router API Ibra AI dan latensi eksekusi sistem secara real-time
model: 9router/is/ag/claude-sonnet-4-6
---

Hasil Pengukuran Latensi Model & Router:
!`python3 - <<'EOF'
import urllib.request, json, time

API_URL = "https://app.ibra.ai.id/v1/chat/completions"
API_KEY = "sk-74719b5a958826c8-wenh6o-7dd6518c"

models = [
    ("ag/gpt-oss-120b-medium", "Ibra X 3.1 Ultra Fast 120B"),
    ("is/ag/claude-sonnet-4-6", "Ibra X 3.1 Sonnet 4.6"),
    ("is/ibra", "Ibra X 3.1 Prime (Utama)")
]

prompt = "Jawab 'OK' dalam 1 kata."

print(f"{'Model':<30} | {'Latensi':<10} | {'Status'}")
print("-" * 55)

for model_id, label in models:
    payload = {
        "model": model_id,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 5,
        "stream": False
    }
    req = urllib.request.Request(
        API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json",
            "User-Agent": "curl/8.0.0"
        }
    )
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            elapsed = time.time() - t0
            print(f"{label:<30} | {elapsed*1000:7.0f}ms | Aktif (200)")
    except Exception as e:
        elapsed = time.time() - t0
        print(f"{label:<30} | {elapsed*1000:7.0f}ms | Kendala: {str(e)[:15]}")
EOF`

Instruksi:
Tinjau metrik latensi di atas dan berikan analisis performa jaringan, pemilihan model paling optimal untuk skenario tugas saat ini, serta rekomendasi penyesuaian streaming/batching.
