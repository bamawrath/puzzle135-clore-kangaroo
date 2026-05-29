#!/usr/bin/env python3
import argparse

PUZZLE_START = int("4000000000000000000000000000000000", 16)
PUZZLE_END   = int("7fffffffffffffffffffffffffffffffff", 16)
PUBKEY = "02145d2611c823a396ef6712ce0f712f09b9b4f3135e3e0aa3230fb9b6d08d1e16"

def main() -> None:
    parser = argparse.ArgumentParser(description="Generate JeanLucPons Kangaroo input file for BTC Puzzle 135 shard.")
    parser.add_argument("--shard-index", type=int, required=True)
    parser.add_argument("--shard-bits", type=int, default=125)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    total_width = PUZZLE_END - PUZZLE_START + 1
    shard_size = 1 << args.shard_bits
    total_shards = (total_width + shard_size - 1) // shard_size

    if args.shard_index < 0 or args.shard_index >= total_shards:
        raise SystemExit(f"shard-index must be 0..{total_shards - 1}; got {args.shard_index}")

    start = PUZZLE_START + args.shard_index * shard_size
    end = min(start + shard_size - 1, PUZZLE_END)

    with open(args.out, "w", encoding="ascii") as f:
        f.write(f"{start:x}\n")
        f.write(f"{end:x}\n")
        f.write(f"{PUBKEY}\n")

    print(f"Wrote {args.out}")
    print(f"Puzzle width : 2^{total_width.bit_length()-1}")
    print(f"Shard bits   : {args.shard_bits}")
    print(f"Total shards : {total_shards}")
    print(f"Shard index  : {args.shard_index}")
    print(f"Shard start  : {start:x}")
    print(f"Shard end    : {end:x}")

if __name__ == "__main__":
    main()
