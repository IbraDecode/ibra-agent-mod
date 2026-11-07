---
name: security-audit
description: Protokol audit keamanan sistem, pencegahan injeksi data (SQL/Command/XSS), proteksi kredensial, dan validasi input.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Security, OWASP, Pentest, DevSecOps, Hardening, InputValidation]
---

# Systematic Security Audit Protocol (Ibra X 3.1)

Daftar periksa audit keamanan kode (*Static Application Security Testing*) untuk memastikan kode bebas dari kerentanan OWASP Top 10 sebelum di-commit atau dirilis.

## 1. Pencegahan Injeksi (SQL & Shell Command)

- **SQL Injection**: Wajib menggunakan parameterized queries atau ORM binding, dilarang merangkai string query:
  ```python
  # ❌ Rawan SQL Injection
  cursor.execute(f"SELECT * FROM users WHERE email = '{user_input}'")

  # ✅ Aman (Parameterized)
  cursor.execute("SELECT * FROM users WHERE email = %s", (user_input,))
  ```
- **Command Injection**: Hindari `shell=True` pada `subprocess` jika menerima argumen dari pengguna luar:
  ```python
  # ✅ Aman: Lewatkan sebagai array argumen terpisah
  subprocess.run(["tar", "-xzf", filename, "-C", target_dir], check=True)
  ```

## 2. Sanitasi Input & Pencegahan XSS

- Escape output HTML saat merender variabel dinamis pada template frontend.
- Gunakan Content Security Policy (CSP) headers yang ketat pada layer reverse proxy / web server.

## 3. Pencegahan Kebocoran Kredensial & Permissions

- Pastikan file token, `.env`, dan private keys (`id_rsa`) berada dalam `.gitignore`.
- Berikan izin paling minim (*least privilege*) pada file eksekusi dan database users.
