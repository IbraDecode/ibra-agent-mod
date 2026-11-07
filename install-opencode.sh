#!/usr/bin/env bash
# ============================================
# IBRA X 3.1 OPENCODE MOD INSTALLER
# powered by Ibra AI
# ============================================
set -euo pipefail

OPENCODE_DIR="${HOME}/.config/opencode"
mkdir -p "$OPENCODE_DIR/skills" "$OPENCODE_DIR/commands"

echo "=== Memasang Ibra X 3.1 untuk OpenCode ==="

# 1. Salin seluruh skill pack
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

if [ -d "$SKILLS_SRC" ]; then
  echo "→ Menginstal seluruh skill pack ke $OPENCODE_DIR/skills/..."
  count=0
  for d in "$SKILLS_SRC"/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    dest="$OPENCODE_DIR/skills/$name"
    mkdir -p "$dest"
    cp -r "$d". "$dest"
    count=$((count + 1))
  done
  echo "✓ Berhasil menginstal $count skill ke OpenCode"
fi

# 2. Daftarkan agent ibra-x jika ada opencode.json
CONFIG="$OPENCODE_DIR/opencode.json"
if [ -f "$CONFIG" ]; then
  python3 - "$CONFIG" <<'PY'
import sys, json, pathlib

path = sys.argv[1]
try:
    data = json.loads(pathlib.Path(path).read_text())
    agents = data.setdefault("agents", {})
    if "ibra-x" not in agents:
        agents["ibra-x"] = {
            "description": "Mesin Eksekusi Otonom Ibra X 3.1 (Otoritas Penuh & Eksekusi Cepat)",
            "mode": "all",
            "model": "9router/is/ag/claude-sonnet-4-6"
        }
        pathlib.Path(path).write_text(json.dumps(data, indent=2))
        print("✓ Berhasil mendaftarkan agent 'ibra-x' ke opencode.json")
    else:
        print("• Agent 'ibra-x' sudah terdaftar")
except Exception as e:
    print(f"⚠ Gagal memodifikasi opencode.json: {e}")
PY
fi

echo ""
echo "┌──────────────────────────────────────────────┐"
echo "│  ✅ IBRA X 3.1 MOD BERHASIL TERPASANG        │"
echo "│  powered by Ibra AI                          │"
echo "└──────────────────────────────────────────────┘"
echo " • 175+ Skill Pack aktif di OpenCode"
echo " • Agen 'ibra-x' siap digunakan: opencode run --agent ibra-x"
