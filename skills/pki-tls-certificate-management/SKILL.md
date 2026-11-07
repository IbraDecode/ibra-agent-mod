---
name: pki-tls-certificate-management
description: Pengelolaan Public Key Infrastructure (PKI), pembuatan internal Certificate Authority (CA) via OpenSSL/cfssl, mutual TLS cert lifecycle, dan rotasi otomatis.
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Security, PKI, TLS, SSL, Certificates, OpenSSL, mTLS, Cryptography]
---

# PKI & Internal TLS Certificate Authority Lifecycle (Ibra X 3.1)

Standar pembuatan dan pengelolaan Certificate Authority (CA) privat untuk mengamankan komunikasi internal mikroservis tanpa ketergantungan pihak ketiga publik.

## 1. Pembuatan Root Certificate Authority (Root CA)

```bash
# 1. Buat Private Key Root CA (Enkripsi RSA 4096 atau ECDSA P-384)
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out rootCA.key
chmod 400 rootCA.key

# 2. Buat Self-Signed Root Certificate (Masa berlaku 10 tahun)
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 \
  -subj "/C=ID/ST=Jakarta/O=Ibra Enterprise/CN=Ibra Root Internal CA" \
  -out rootCA.crt
```

## 2. Penerbitan Sertifikat Layanan Internal (SAN-Enabled)

```bash
# 1. Buat private key untuk mikroservis
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out service.key

# 2. Buat CSR (Certificate Signing Request)
openssl req -new -key service.key -out service.csr \
  -subj "/C=ID/ST=Jakarta/O=Ibra Enterprise/CN=api.internal"

# 3. Tanda tangani dengan Subject Alternative Name (SAN)
cat <<EOF > san.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = api.internal
DNS.2 = *.api.internal
IP.1 = 127.0.0.1
EOF

openssl x509 -req -in service.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
  -out service.crt -days 365 -sha256 -extfile san.ext
```
