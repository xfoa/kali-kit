#!/bin/bash

set -eu

readonly ISO_FILE='kali-kit.iso'

mkdir -p "build"
rm "build/${ISO_FILE:?ISO file name wasn\'t set!}" 2> /dev/null || true
xorriso -outdev "build/$ISO_FILE" -joliet off -map src/iso / -volid KALI_KIT
