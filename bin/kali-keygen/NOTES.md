# Kali 1.4a reverse engineering notes

## Serial validation algorithm

The serial validation is performed after the config file (`kali.cfg`) is parsed.
Relevant buffers in the data segment:
- `SERIAL` → DS:0x4e72 (copied with `memcpy`, max 12 chars + null = 13 bytes)
- `SKEY` → DS:0x4e8f (copied with `memcpy`, max 12 chars = 12 bytes)
- `NICKNAME` → DS:0x4e7f
- `EMAIL` → DS:0x4ee6
- `REALNAME` → DS:0x4e9b
- `LOCATION` → DS:0x4f88

### Validation steps (Path 2 at CS:0x7db8)

1. **Check SERIAL is non-empty**: `cmp byte [0x4e72], 0`
2. **Parse seed**: `atoi(DS:0x4e78)` — parses from `SERIAL[6]` (6 chars into the buffer)
3. **Seed PRNG**: `call 0x074d` with the atoi result
4. **Generate value**: `call 0x075e` — 32-bit LCG
   - `state = (seed * 0x015a4e35 + 1)`
   - `value = (state >> 16) & 0x7FFF`
5. **Format value**: `sprintf(buffer, "%04x", value)`
6. **Compare SKEY**: `strncmp(SKEY+8, buffer, 4)`
7. **Check length**: `strlen(SERIAL) == 12`
   - **This is critical**: The serial MUST be exactly 12 characters.
   - A 10-character serial like "KALI000123" will fail here.

If any check fails, the program prints:
```
Invalid serial number!
```

If the serial is valid, the program then checks that `NICKNAME`, `EMAIL`, `REALNAME`, and `LOCATION` are all non-empty.

### 16-bit DOS atoi truncation

`atoi()` in the 16-bit DOS binary truncates the result to 16 bits. The effective seed is:
```
seed = atoi(SERIAL[6:]) & 0xFFFF
```

### Serial format

Real Kali 1.4a serials are 12-character strings. The last 6 characters (positions 6-11) must be decimal digits that form the seed. The first 6 characters can be any printable characters.

For simplicity, this keygen generates serials as:
```
"KALI" + f"{seed:08d}"
```
Which produces 12-character serials like `KALI00003637`.

The substring from position 6 is `003637`, which `atoi()` parses as `3637`.

### SKEY format

The SKEY must be at least 12 characters. Only the last 4 characters (positions 8-11) matter — they must match the hex-formatted PRNG output.

For seed 3637:
- PRNG output = 0x37f9
- Valid SKEYs: `AAAAAAAA37f9`, `3d69097537f9`, `xxxxxxxx37f9`, etc.

## 15-minute timer

The demo timer is located at file offset 0x67a5. It counts down from 900 seconds (15 minutes).

To disable it, patch at file offset 0x679a:
- Original: `75 18` (JNZ)
- Patched: `EB 21` (JMP)

This skips the timer initialization entirely.

## Config parser

The config parser reads `kali.cfg` line by line. It recognizes these keys (case-insensitive):
- `NICKNAME` → copies up to 15 chars with `strncpy` (null-padded)
- `SERIAL` → copies up to 12 chars with `memcpy` (NOT null-padded beyond source null)
- `SKEY` → copies up to 12 chars with `memcpy`
- `TKEY` → copies up to 12 chars with `memcpy`
- `EMAIL` → copies up to 75 chars with `memcpy`
- `REALNAME` → copies up to 75 chars with `memcpy`
- `LOCATION` → copies up to 75 chars with `memcpy`

**Important**: The parser does NOT trim trailing whitespace from values. If a line like `serial = KALI00000123   ` has trailing spaces, the SERIAL buffer will contain those spaces and `strlen()` will return > 12, causing validation to fail.

## Required config for registration

For the serial validation to succeed and the program to run in full mode, the config file must contain:
```
nickname = <string>
realname = <string>
email = <string>
location = <string>
serial = <12-char serial>
skey = <12-char skey>
```
