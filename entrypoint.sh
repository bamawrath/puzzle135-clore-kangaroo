#!/usr/bin/env bash
set -euo pipefail

echo "=== Puzzle 135 Clore Kangaroo Runner ==="
echo "WORKDIR=${WORKDIR}"
echo "BUILD_DIR=${BUILD_DIR}"
echo "SHARD_INDEX=${SHARD_INDEX}"
echo "SHARD_BITS=${SHARD_BITS}"
echo "GPU_IDS=${GPU_IDS}"
echo "DP=${DP}"
echo "WI=${WI}"

mkdir -p "${WORKDIR}" "${BUILD_DIR}"

if command -v nvidia-smi >/dev/null 2>&1; then
  echo "=== NVIDIA GPUs ==="
  nvidia-smi || true
fi

detect_ccap() {
  if command -v nvidia-smi >/dev/null 2>&1; then
    local cap
    cap="$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader 2>/dev/null | head -n1 | tr -d '. ')"
    if [[ -n "${cap}" ]]; then
      echo "${cap}"
      return
    fi
  fi
  echo "${CCAP:-86}"
}

CCAP="${CCAP:-$(detect_ccap)}"
echo "Using CUDA compute capability ccap=${CCAP}"

if [[ ! -d "${BUILD_DIR}/Kangaroo/.git" ]]; then
  echo "Cloning Kangaroo source..."
  rm -rf "${BUILD_DIR}/Kangaroo"
  git clone --depth 1 "${KANGAROO_REPO}" "${BUILD_DIR}/Kangaroo"
fi

cd "${BUILD_DIR}/Kangaroo"

if [[ "${FORCE_REBUILD}" == "1" || ! -x ./kangaroo ]]; then
  echo "Building Kangaroo GPU binary..."
  make clean || true
  make gpu=1 ccap="${CCAP}" CUDA=/usr/local/cuda all
else
  echo "Using existing Kangaroo binary."
fi

INPUT_FILE="${WORKDIR}/puzzle135-shard-${SHARD_INDEX}.in"
RESULT_FILE="${RESULT_FILE:-${WORKDIR}/puzzle135-result-shard-${SHARD_INDEX}.txt}"
WORK_FILE="${WORK_FILE:-${WORKDIR}/puzzle135-shard-${SHARD_INDEX}.work}"

python3 /app/make_puzzle135_shard.py \
  --shard-index "${SHARD_INDEX}" \
  --shard-bits "${SHARD_BITS}" \
  --out "${INPUT_FILE}"

echo "=== Kangaroo input ==="
cat "${INPUT_FILE}"

CMD=(./kangaroo -gpu -gpuId "${GPU_IDS}" -d "${DP}" -w "${WORK_FILE}" -wi "${WI}" -ws -o "${RESULT_FILE}")

if [[ -n "${GRID:-}" ]]; then
  CMD+=(-g "${GRID}")
fi

if [[ -f "${WORK_FILE}" && "${RESUME:-1}" == "1" ]]; then
  echo "Resuming from work file: ${WORK_FILE}"
  CMD+=(-i "${WORK_FILE}")
else
  echo "Starting fresh shard work."
fi

CMD+=("${INPUT_FILE}")

echo "=== Running command ==="
printf '%q ' "${CMD[@]}"
echo

exec "${CMD[@]}"
