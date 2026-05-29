# Puzzle 135 Clore Kangaroo Runner

Clore-ready Linux/CUDA runner for BTC Puzzle #135.

## Why this package uses JeanLucPons/Kangaroo

The uploaded `Etarkangaroo` source package is marked Windows-only and PureBasic-based. For Clore Linux/CUDA, this package instead builds the Linux JeanLucPons `Kangaroo` implementation inside a CUDA container.

JeanLucPons/Kangaroo is limited to a 125-bit interval. Puzzle #135 is a 134-bit interval, so this runner splits Puzzle #135 into 512 separate 125-bit shards.

## Puzzle 135 parameters

Address:

```text
16RGFo6hjq9ym6Pj7N5H7L1NR1rVPJyw2v
```

Public key:

```text
02145d2611c823a396ef6712ce0f712f09b9b4f3135e3e0aa3230fb9b6d08d1e16
```

Full range:

```text
4000000000000000000000000000000000
7fffffffffffffffffffffffffffffffff
```

## Build locally

```bash
docker build -t puzzle135-kangaroo .
```

## Run shard 0

```bash
docker run --rm --gpus all \
  -e SHARD_INDEX=0 \
  -e SHARD_BITS=125 \
  -e GPU_IDS=0 \
  -e DP=30 \
  -e WI=300 \
  -v "$PWD/work:/work" \
  puzzle135-kangaroo
```

## Run a different shard

```bash
docker run --rm --gpus all \
  -e SHARD_INDEX=123 \
  -e SHARD_BITS=125 \
  -e GPU_IDS=0 \
  -e DP=30 \
  -e WI=300 \
  -v "$PWD/work:/work" \
  puzzle135-kangaroo
```

## Useful environment variables

| Variable | Default | Meaning |
|---|---:|---|
| `SHARD_INDEX` | `0` | Which 125-bit shard to search. Valid range is 0-511. |
| `SHARD_BITS` | `125` | Interval width per shard. Keep 125 for JeanLucPons limit. |
| `GPU_IDS` | `0` | GPU IDs passed to Kangaroo. Example: `0,1`. |
| `DP` | `30` | Distinguished point bits. Tune per GPU/memory. |
| `GRID` | unset | Optional Kangaroo `-g` grid string, for example `88,128`. |
| `WI` | `300` | Work save interval in seconds. |
| `RESUME` | `1` | Resume from existing work file if present. |
| `FORCE_REBUILD` | `0` | Set to `1` to rebuild Kangaroo on container start. |
| `CCAP` | auto | CUDA compute capability, auto-detected via `nvidia-smi` when possible. |

## Clore notes

Use a public GitHub repository containing this Dockerfile and scripts. On Clore, choose an NVIDIA GPU host and build/run the container with GPU access.

For rented GPUs, keep a persistent volume mounted to `/work` so Kangaroo checkpoints survive restarts.

## Operational note

This is not a quick single-GPU solve. It is a checkpointed, shardable, long-running interval ECDLP search. Each shard should be logged so the same shard is not repeated across workers.
