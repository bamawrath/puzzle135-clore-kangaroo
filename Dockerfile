FROM nvidia/cuda:12.4.1-base-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV KANGAROO_REPO=https://github.com/JeanLucPons/Kangaroo.git
ENV WORKDIR=/work
ENV BUILD_DIR=/opt/kangaroo

# Use random by default so Clore workers do not all start at shard 0.
ENV SHARD_INDEX=random
ENV SHARD_BITS=125
ENV SHARD_MIN=0
ENV SHARD_MAX=511

ENV GPU_IDS=0
ENV DP=40
ENV WI=300
ENV FORCE_REBUILD=0
ENV RESUME=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    build-essential \
    make \
    python3 \
    bash \
    coreutils \
    pciutils \
    cuda-nvcc-12-4 \
    cuda-cudart-dev-12-4 \
    && ln -sf /usr/bin/g++ /usr/bin/g++-4.8 \
    && ln -sfn /usr/local/cuda-12.4 /usr/local/cuda \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt /work /app

COPY entrypoint.sh /app/entrypoint.sh
COPY scripts/make_puzzle135_shard.py /app/make_puzzle135_shard.py
RUN chmod +x /app/entrypoint.sh

WORKDIR /work

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]