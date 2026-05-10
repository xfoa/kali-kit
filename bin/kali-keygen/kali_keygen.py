#!/usr/bin/env python3
"""
Kali DOS 1.4 Registration Key Generator

The serial must be exactly 12 characters.
The validation algorithm:
1. Reads SERIAL from kali.cfg (copied to DS:0x4e72, max 12 chars + null)
2. Calls atoi(DS:0x4e78) which parses from SERIAL[6]
3. Seeds PRNG with the atoi result (16-bit truncation: seed & 0xFFFF)
4. Generates next PRNG value: state = (seed * 0x015a4e35 + 1), value = (state >> 16) & 0x7FFF
5. Formats value as "%04x"
6. Compares 4 bytes at SKEY+8 (DS:0x4e97) against the formatted value
7. Checks strlen(SERIAL) == 12

Serial format: 12 characters total. The last 6 characters (positions 6-11)
must be decimal digits that form the seed. The first 6 can be any characters.

For simplicity we generate: "KALI" + f"{seed:08d}" (4 + 8 = 12 chars)
The substring from position 6 is the last 6 digits of the 8-digit padding,
which equals the seed (with leading zeros).
"""

import random


def generate_skey(seed: int) -> str:
    """Generate the SKEY for a given seed."""
    state = (seed * 0x015a4e35 + 1) & 0xFFFFFFFF
    value = (state >> 16) & 0x7FFF
    return f"AAAAAAAA{value:04x}"


def generate_pair(prefix: str = "KALI", serial_num: int = None) -> tuple[str, str]:
    """
    Generate a valid SERIAL + SKEY pair.
    
    Args:
        prefix: 4-character prefix (default "KALI")
        serial_num: Seed value (0-999999). If None, a random seed is chosen.
    
    Returns:
        (serial, skey) tuple
    """
    if serial_num is None:
        serial_num = random.randint(0, 999999)
    
    if len(prefix) != 4:
        raise ValueError("prefix must be exactly 4 characters")
    if not (0 <= serial_num <= 999999):
        raise ValueError("serial_num must be between 0 and 999999")
    
    # Serial must be exactly 12 characters.
    # Format: prefix (4 chars) + 8-digit zero-padded number = 12 chars.
    # atoi(SERIAL+6) parses positions 6-11, which is the last 6 digits of
    # the 8-digit padding, i.e. the seed with leading zeros.
    serial = f"{prefix}{serial_num:08d}"
    assert len(serial) == 12, f"Serial length is {len(serial)}, expected 12"
    
    # In 16-bit DOS, atoi truncates to 16 bits. The effective seed is serial_num & 0xFFFF.
    seed_16bit = serial_num & 0xFFFF
    skey = generate_skey(seed_16bit)
    
    return serial, skey


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Generate Kali DOS 1.4 registration keys")
    parser.add_argument("--seed", type=int, help="Specific seed (0-999999)")
    parser.add_argument("--prefix", default="KALI", help="Serial prefix (default: KALI)")
    parser.add_argument("--count", type=int, default=1, help="Number of keys to generate")
    args = parser.parse_args()
    
    for i in range(args.count):
        if args.seed is not None:
            serial, skey = generate_pair(prefix=args.prefix, serial_num=args.seed)
        else:
            serial, skey = generate_pair(prefix=args.prefix)
        
        print(f"SERIAL: {serial}")
        print(f"SKEY:   {skey}")
        print()


if __name__ == "__main__":
    main()
