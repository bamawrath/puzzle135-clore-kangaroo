#!/usr/bin/env bash
set -euo pipefail
docker build -t puzzle135-kangaroo .
mkdir -p work
docker run --rm --gpus all \
  -e SHARD_INDEX="${SHARD_INDEX:-0}" \
  -e SHARD_BITS="${SHARD_BITS:-125}" \
  -e GPU_IDS="${GPU_IDS:-0}" \
  -e DP="${DP:-30}" \
  -e WI="${WI:-300}" \
  -v "$PWD/work:/work" \
  puzzle135-kangaroo
