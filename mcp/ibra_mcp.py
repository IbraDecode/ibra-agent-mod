#!/usr/bin/env python3
"""
IBRA X 3.1 CORE MCP SERVER
Protocol: Model Context Protocol (JSON-RPC 2.0 over stdio)
Standar: Pure Python 3 (Tanpa dependensi eksternal)
Author: Ibra Ramdan <ibradecode@gmail.com>
"""

import sys
import json
import os
import subprocess
import socket
import urllib.request
import time

TOOLS = [
    {
        "name": "ibra_system_diagnostics",
        "description": "Mengambil metrik kesehatan sistem secara instan (RAM, Disk, CPU Load, Uptime, dan Status Docker).",
        "inputSchema": {
            "type": "object",
            "properties": {},
            "required": []
        }
    },
    {
        "name": "ibra_port_checker",
        "description": "Memeriksa apakah host dan port target tertentu terbuka dan dapat diakses (TCP connect test).",
        "inputSchema": {
            "type": "object",
            "properties": {
                "host": {"type": "string", "description": "Hostname atau alamat IP target"},
                "port": {"type": "integer", "description": "Nomor port TCP target"},
                "timeout": {"type": "number", "description": "Batas waktu koneksi dalam detik (default: 3)"}
            },
            "required": ["host", "port"]
        }
    },
    {
        "name": "ibra_http_inspect",
        "description": "Memeriksa status HTTP, header respons, latensi transfer, dan tipe konten dari URL target.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "url": {"type": "string", "description": "URL target lengkap (misal: https://example.com)"},
                "method": {"type": "string", "description": "Metode HTTP (GET/HEAD, default: GET)"}
            },
            "required": ["url"]
        }
    }
]

def handle_system_diagnostics():
    mem_info = "N/A"
    try:
        with open("/proc/meminfo") as f:
            lines = f.readlines()
            total = int([l for l in lines if "MemTotal:" in l][0].split()[1]) // 1024
            avail = int([l for l in lines if "MemAvailable:" in l][0].split()[1]) // 1024
            used = total - avail
            mem_info = f"RAM Terpakai: {used}MB / {total}MB ({used/total*100:.1f}%)"
    except Exception as e:
        mem_info = str(e)

    load_avg = "N/A"
    try:
        load = os.getloadavg()
        load_avg = f"Load (1m, 5m, 15m): {load[0]:.2f}, {load[1]:.2f}, {load[2]:.2f}"
    except Exception:
        pass

    disk_info = "N/A"
    try:
        st = os.statvfs("/")
        total_disk = (st.f_blocks * st.f_frsize) // (1024 * 1024 * 1024)
        free_disk = (st.f_bavail * st.f_frsize) // (1024 * 1024 * 1024)
        used_disk = total_disk - free_disk
        disk_info = f"Disk Root (/): {used_disk}GB terpakai dari {total_disk}GB ({free_disk}GB sisa)"
    except Exception:
        pass

    docker_status = "Tidak aktif"
    try:
        res = subprocess.run(["docker", "ps", "-q"], capture_output=True, text=True, timeout=2)
        if res.returncode == 0:
            containers = len([c for c in res.stdout.strip().split("\n") if c])
            docker_status = f"Aktif ({containers} container berjalan)"
    except Exception:
        pass

    report = (
        f"📊 METRIK SISTEM REAL-TIME (IBRA X 3.1):\n"
        f"• {mem_info}\n"
        f"• {load_avg}\n"
        f"• {disk_info}\n"
        f"• Docker Engine: {docker_status}\n"
        f"• Hostname: {socket.gethostname()}"
    )
    return report

def handle_port_checker(host, port, timeout=3.0):
    t0 = time.time()
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, int(port)))
        sock.close()
        elapsed = (time.time() - t0) * 1000
        if result == 0:
            return f"✅ Port {port} pada {host} TERBUKA (Koneksi berhasil dalam {elapsed:.1f}ms)."
        else:
            return f"❌ Port {port} pada {host} TERTUTUP atau DIBLOKIR (Error Code: {result})."
    except Exception as e:
        return f"⚠ Gagal memeriksa {host}:{port} - Kesalahan: {str(e)}"

def handle_http_inspect(url, method="GET"):
    t0 = time.time()
    try:
        req = urllib.request.Request(url, method=method.upper())
        req.add_header("User-Agent", "IbraX-MCP-Inspector/3.1")
        with urllib.request.urlopen(req, timeout=10) as resp:
            elapsed = (time.time() - t0) * 1000
            headers = dict(resp.headers)
            header_lines = "\n".join([f"  {k}: {v}" for k, v in list(headers.items())[:12]])
            return (
                f"🌐 HASIL INSPEKSI HTTP:\n"
                f"• URL Target  : {url}\n"
                f"• Status Code : {resp.status} {resp.reason}\n"
                f"• Waktu Respons: {elapsed:.1f}ms\n"
                f"• Headers (12 Teratas):\n{header_lines}"
            )
    except urllib.error.HTTPError as e:
        elapsed = (time.time() - t0) * 1000
        return f"⚠ HTTP Error {e.code}: {e.reason} ({elapsed:.1f}ms) untuk URL {url}"
    except Exception as e:
        return f"❌ Gagal menghubungi {url}: {str(e)}"

def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except Exception:
            continue

        method = req.get("method")
        msg_id = req.get("id")

        if method == "initialize":
            resp = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {"tools": {}},
                    "serverInfo": {"name": "ibra-core-mcp", "version": "3.1.0"}
                }
            }
            sys.stdout.write(json.dumps(resp) + "\n")
            sys.stdout.flush()

        elif method == "notifications/initialized":
            # Tidak perlu membalas notifikasi
            continue

        elif method == "tools/list":
            resp = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {"tools": TOOLS}
            }
            sys.stdout.write(json.dumps(resp) + "\n")
            sys.stdout.flush()

        elif method == "tools/call":
            params = req.get("params", {})
            name = params.get("name")
            args = params.get("arguments", {})

            text_output = ""
            if name == "ibra_system_diagnostics":
                text_output = handle_system_diagnostics()
            elif name == "ibra_port_checker":
                text_output = handle_port_checker(
                    args.get("host"),
                    args.get("port"),
                    args.get("timeout", 3.0)
                )
            elif name == "ibra_http_inspect":
                text_output = handle_http_inspect(
                    args.get("url"),
                    args.get("method", "GET")
                )
            else:
                text_output = f"Unknown tool: {name}"

            resp = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "result": {
                    "content": [{"type": "text", "text": text_output}]
                }
            }
            sys.stdout.write(json.dumps(resp) + "\n")
            sys.stdout.flush()

        elif msg_id is not None:
            # Method tidak dikenal namun membutuhkan respon
            resp = {
                "jsonrpc": "2.0",
                "id": msg_id,
                "error": {"code": -32601, "message": f"Method {method} not found"}
            }
            sys.stdout.write(json.dumps(resp) + "\n")
            sys.stdout.flush()

if __name__ == "__main__":
    main()
