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

# 2. Salin custom commands
COMMANDS_SRC="$SCRIPT_DIR/commands"
if [ -d "$COMMANDS_SRC" ]; then
  echo "→ Menginstal perintah kustom ke $OPENCODE_DIR/commands/..."
  cp -r "$COMMANDS_SRC"/*.md "$OPENCODE_DIR/commands/"
  echo "✓ Berhasil menginstal perintah kustom (/status, /tinjau, /perbaiki, /farm, /recon, dll.)"
fi

# 3. Daftarkan agent ibra-x jika ada opencode.json
CONFIG="$OPENCODE_DIR/opencode.json"
if [ -f "$CONFIG" ]; then
  python3 - "$CONFIG" "$SCRIPT_DIR/mcp/ibra_mcp.py" <<'PY'
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
        print("✓ Berhasil mendaftarkan agent 'ibra-x' ke opencode.json")
    else:
        print("• Agent 'ibra-x' sudah terdaftar")

    # Daftarkan ibra-core MCP Server
    mcp_servers = data.setdefault("mcp", {}).setdefault("servers", {})
    mcp_script = str(pathlib.Path(sys.argv[2]).resolve()) if len(sys.argv) > 2 else ""
    if mcp_script and pathlib.Path(mcp_script).exists():
        mcp_servers["ibra-core"] = {
            "type": "local",
            "command": ["python3", mcp_script]
        }
        print("✓ Berhasil mendaftarkan MCP Server 'ibra-core'")

    pathlib.Path(path).write_text(json.dumps(data, indent=2))
except Exception as e:
    print(f"⚠ Gagal memodifikasi opencode.json: {e}")
PY
fi

# 4. Pasang CLI Utility ibra
CLI_BIN="$SCRIPT_DIR/bin/ibra"
if [ -f "$CLI_BIN" ]; then
  chmod +x "$CLI_BIN"
  TARGET_BIN="/usr/local/bin/ibra"
  if [ -w "/usr/local/bin" ]; then
    ln -sf "$CLI_BIN" "$TARGET_BIN"
    echo "✓ CLI Utility 'ibra' berhasil dipasang ke $TARGET_BIN"
  elif [ -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$CLI_BIN" "$HOME/.local/bin/ibra"
    echo "✓ CLI Utility 'ibra' berhasil dipasang ke $HOME/.local/bin/ibra"
  fi
fi

echo ""
echo "┌──────────────────────────────────────────────┐"
echo "│  ✅ IBRA X 3.1 MOD BERHASIL TERPASANG        │"
echo "│  powered by Ibra AI                          │"
echo "└──────────────────────────────────────────────┘"
echo " • 175+ Skill Pack aktif di OpenCode"
echo " • Agen 'ibra-x' siap digunakan: opencode run --agent ibra-x"
