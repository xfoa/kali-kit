#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/../lib/helpers.sh"
readonly DEPS=(ip vde_switch)
check_deps DEPS

show_usage() {
	cat << EOF >&2
$(basename "$0") [--help|-h] TAP_DEVICE
Start a VDE bridge with a TAP device connected to it.

	TAP_DEVICE	Interface name of the TAP device to connect to VDE. Must already exist.
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
	case "$1" in
		--help|-h)
			show_usage
			exit 1
			;;
		-*|--*)
			echo "Unknown parameter $1" >&2
			exit 1
			;;
		*)
			PARGS+=("$1")
			shift
			;;
	esac
done

set -- "${PARGS[@]}"

# Set up vars
readonly TAP_DEVICE="${1?No TAP device supplied}"
readonly SWITCH_DIR="/tmp/vde.$TAP_DEVICE"

# Make sure TAP exists
ip link show "$TAP_DEVICE" > /dev/null
readonly TAP_FOUND="$?"
if [[ ! $TAP_FOUND ]]
then
	echo "TAP device $TAP_DEVICE doesn't exist in dev. Create it by running 'create-tap-device.sh'" >&2
	exit 1
fi

# Start VDE
vde_switch --mode 666 --numports 8 --tap "$TAP_DEVICE" --mgmt /tmp/vde.mgmt --mgmtmode 666 -s "$SWITCH_DIR" --daemon
echo "Started VDE switch at $SWITCH_DIR with TAP interface $TAP_DEVICE attached. To stop it, kill the 'vde_switch' process."
