# Puzzle 135 Clore Kangaroo

Clore-ready GitHub source build for BTC Puzzle #135.

## Clore settings

Use this public GitHub repo as the source.

Dockerfile path:

Dockerfile

No custom command is needed.

## Random shard mode

Default mode is random shard selection so Clore workers do not all start at shard 0.

Recommended Clore environment variables:

SHARD_INDEX=random
SHARD_BITS=125
SHARD_MIN=50
SHARD_MAX=511
GPU_IDS=0
DP=40
WI=300

The container writes the selected shard to:

/work/selected-shard.txt

## Manual shard mode

Use this when you want to assign a specific shard:

SHARD_INDEX=181
SHARD_BITS=125
GPU_IDS=0
DP=40
WI=300

Valid shard indexes:

0 through 511

## Puzzle 135 public key

02145d2611c823a396ef6712ce0f712f09b9b4f3135e3e0aa3230fb9b6d08d1e16

## Puzzle 135 range

4000000000000000000000000000000000
7fffffffffffffffffffffffffffffffff

## Notes

The full 134-bit interval is split into 512 shards of 125 bits each so the Linux Kangaroo build can process the search in chunks.

For Clore, use SHARD_INDEX=random and SHARD_MIN=50 to avoid the most obvious early shards.
