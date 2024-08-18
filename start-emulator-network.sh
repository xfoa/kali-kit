#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/lib/helpers.sh"
readonly DEPS=(grep sed)
check_deps DEPS

readonly BASE_NAME='86box'

echo 'Setting up emulator networking with the following settings:'
echo "  * TAP device base name: $BASE_NAME"
echo "  * TAP device user: $USER"
echo "  * TAP device IP: 10.1.0.1/16"

DO_IT=''
while [[ "${DO_IT}" != 'Y' && "${DO_IT}" != 'N' ]]
do
	read -p 'Continue? [y/N] ' DO_IT
	DO_IT=${DO_IT^^}
	if [[ -z "$DO_IT" || "$DO_IT" == 'N' ]]
	then
		exit 0
	fi
done

readonly TAPDEV="$(sudo "$SCRIPT_DIR/bin/create-tap-device.sh" --tap-name "$BASE_NAME" "$USER" | grep 'TAP device' | sed 's/TAP device \(.*\) for.*/\1/')"
"$SCRIPT_DIR/bin/start-vde.sh" "$TAPDEV"
sudo "$SCRIPT_DIR/bin/route-tap-to-gateway.sh" "$TAPDEV"
