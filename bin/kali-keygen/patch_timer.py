#!/usr/bin/env python3
"""
Kali DOS 1.4 Timer Bypass Patch

Applies a 2-byte patch to the decompressed KALI.EXE that disables the
15-minute demo timer by forcing an unconditional jump over all timer and
serial checks in the network packet-processing callback.

Usage:
    python3 patch_timer.py <input.exe> <output.exe>
    python3 patch_timer.py /tmp/kali_deark.000.exe KALI_PATCHED.EXE

The patch modifies file offset 0x679a:
    75 18  ->  EB 21
    (JNZ +0x18) -> (JMP +0x21)

This skips the [0x0d5c] expiry flag check, the 32-bit tick counter check,
and the serial-existence check, landing directly on normal packet processing.
"""

import sys
import os

PATCH_OFFSET = 0x679a
ORIGINAL_BYTES = bytes([0x75, 0x18])
PATCHED_BYTES = bytes([0xEB, 0x21])


def patch(input_path: str, output_path: str):
    with open(input_path, "rb") as f:
        data = bytearray(f.read())

    if len(data) < PATCH_OFFSET + 2:
        raise ValueError(f"File too small ({len(data)} bytes)")

    current = bytes(data[PATCH_OFFSET:PATCH_OFFSET + 2])
    if current == PATCHED_BYTES:
        print(f"[*] File already patched at 0x{PATCH_OFFSET:04x}")
    elif current == ORIGINAL_BYTES:
        data[PATCH_OFFSET:PATCH_OFFSET + 2] = PATCHED_BYTES
        print(f"[+] Patched 0x{PATCH_OFFSET:04x}: {ORIGINAL_BYTES.hex()} -> {PATCHED_BYTES.hex()}")
    else:
        raise ValueError(
            f"Unexpected bytes at 0x{PATCH_OFFSET:04x}: {current.hex()} "
            f"(expected {ORIGINAL_BYTES.hex()} or {PATCHED_BYTES.hex()})"
        )

    with open(output_path, "wb") as f:
        f.write(data)

    print(f"[+] Wrote patched file: {output_path} ({len(data)} bytes)")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.exe> <output.exe>")
        sys.exit(1)

    patch(sys.argv[1], sys.argv[2])
