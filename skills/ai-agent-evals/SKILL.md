---
name: ai-agent-evals
description: Metodologi evaluasi kinerja agen AI (akurasi pemanggilan tool, penahanan halusinasi, rasio sukses tugas otonom, dan ekonomi token).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [AI, Agents, Evaluation, Benchmarking, LLM, Observability, Metrics]
---

# AI Agent Evaluation & Quality Gates (Ibra X 3.1)

Framework standar untuk mengukur reliabilitas, presisi alat, dan stabilitas perilaku agen otonom sebelum digunakan dalam produksi skala besar.

## 1. Empat Dimensi Metrik Evaluasi Agen

1. **Task Completion Rate (TCR)**: Persentase tugas nyata yang diselesaikan secara tuntas dan lulus verifikasi otomatis (*assertion-based scoring*).
2. **Tool Call Precision & Recall**: Mengukur apakah agen memanggil alat yang tepat dengan argumen yang benar tanpa *infinite tool loops*.
3. **Hallucination Containment**: Memverifikasi bahwa seluruh klaim, path file, dan output status didukung oleh bukti nyata (*evidence-gated*).
4. **Token & Latency Economics**: Mengukur rasio biaya token input/output per tugas dan waktu penyelesaian (*wall-clock latency*).

## 2. Test Harness Otomatis untuk Agen (Python)

```python
import subprocess, time, json

TEST_CASES = [
    {
        "name": "File Creation & Verify",
        "instruction": "Buat file /tmp/eval_test.txt dengan teks 'PASSED' lalu pastikan file tersebut ada.",
        "validator": lambda: open("/tmp/eval_test.txt").read().strip() == "PASSED"
    },
    {
        "name": "Syntax Safe Python Generation",
        "instruction": "Tulis fungsi fibonacci di /tmp/fib.py",
        "validator": lambda: subprocess.run(["python3", "-m", "py_compile", "/tmp/fib.py"]).returncode == 0
    }
]

def run_eval_suite():
    scores = []
    for tc in TEST_CASES:
        t0 = time.time()
        print(f"▶ Menjalankan pengujian: {tc['name']}...")
        res = subprocess.run(["ibra", "run", tc["instruction"]], capture_output=True, text=True, timeout=90)
        elapsed = time.time() - t0
        passed = False
        try:
            passed = tc["validator"]()
        except Exception as e:
            passed = False
        status = "✅ LULUS" if passed else "❌ GAGAL"
        print(f"  {status} ({elapsed:.1f}s)")
        scores.append(passed)

    rate = (sum(scores) / len(scores)) * 100
    print(f"\nSkor Evaluasi Agen Akhir: {rate:.1f}% ({sum(scores)}/{len(scores)})")

if __name__ == "__main__":
    run_eval_suite()
```
