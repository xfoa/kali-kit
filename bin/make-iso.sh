#!/bin/bash

set -eu

readonly REPO_ROOT="$(git rev-parse --show-toplevel)"
pushd "$REPO_ROOT"
rm build/kali_kit.iso 2>/dev/null || true
xorriso -outdev build/kali_kit.iso -joliet off -map iso / -volid KALI_KIT
popd
