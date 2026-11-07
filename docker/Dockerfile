# ==============================================================================
# IBRA X 3.1 DOCKER SANDBOX
# Lingkungan eksekusi terisolasi untuk agen otonom
# ==============================================================================
FROM ubuntu:24.04

LABEL maintainer="Ibra Ramdan <ibradecode@gmail.com>"
LABEL version="3.1.4"
LABEL description="Ibra X 3.1 Sovereign Coding Agent Sandbox"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV PATH="/root/.opencode/bin:/root/.local/bin:/usr/local/bin:$PATH"

# 1. Pasang paket dasar & dependensi
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    jq \
    python3 \
    python3-pip \
    ca-certificates \
    procps \
    tar \
    gzip \
    && rm -rf /var/lib/apt/lists/*

# 2. Pasang OpenCode CLI
RUN curl -fsSL https://opencode.ai/install.sh | bash

# 3. Setup workspace & mod
WORKDIR /root/ibra-agent-mod
COPY . /root/ibra-agent-mod/

# 4. Jalankan installer Ibra X 3.1
RUN bash install.sh opencode

WORKDIR /workspace

ENTRYPOINT ["ibra"]
CMD ["menu"]
