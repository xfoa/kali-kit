#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/lib/helpers.sh"
readonly DEPS=(grep sed)
check_deps DEPS

show_usage() {
	cat << EOF >&2
$(basename "$0") [--help|-h] [--tap-name|-n NAME] [--bridge|-b BRIDGE] [--user USER]
Create a TAP device attached to a VDE/2 switch and route its traffic to the internet via the default gateway using NAT.
Note: you must use the scripts in 'bin' directly if you want to set up a bridged rather than a routed network.

	--help | -h		Display this usage message.
	--tap-name | -n NAME	Base name of the TAP device to create, without a number at the end. Defaults to 'tap'.
        --tap-ip | -i IP	Specify an IP (with subnet prefix length) the TAP interface will use. Defaults to '10.1.0.1/16'.
	--user | -u  USER	Username that will own the created TAP device. Defaults to the current user.
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--help|-h)
			show_usage
			exit 1
			;;
		--tap-name|-n)
			readonly TAP_NAME_GIVEN="${2:?No tap name supplied}"
			shift
			shift
			;;
		--tap-ip|-i)
			readonly TAP_IP_GIVEN="${2:?No IP supplied}"
			if [[ ! "$TAP_IP_GIVEN" =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$ ]]
			then
				echo "Error: invalid IP '$TAP_IP_GIVEN' -- must be in CIDR notation with a / prefix." >&2
				exit 1
			fi
			shift
			shift
			;;
		--user|-u)
			readonly USERNAME_GIVEN="${2:?No username supplied}"
			shift
			shift
			;;
		*)
			echo "Unknown parameter: $1" >&2
			exit 1
			;;
	esac
done

readonly USERNAME="${USERNAME_GIVEN:-$USER}"
readonly TAP_NAME="${TAP_NAME_GIVEN:-86box}"
readonly TAP_IP="${TAP_IP_GIVEN:-10.1.0.1/16}"

echo 'Setting up emulator networking with the following default settings:'
echo "  * TAP device base name: $TAP_NAME"
echo "  * TAP device user: $USERNAME"
echo "  * TAP device IP: $TAP_IP"
echo
echo "If you want to change the above parameters, abort this script and re-run it with '--help' for information on how to do this."
echo "Note: you must use the scripts in 'bin' directly instead of this script if you want to set up a bridged rather than a routed network."

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

readonly TAPDEV="$(sudo "$SCRIPT_DIR/bin/create-tap-device.sh" --tap-name "$TAP_NAME" --tap-ip "$TAP_IP" "$USERNAME" | grep 'TAP device' | sed 's/TAP device \(.*\) for.*/\1/')"
"$SCRIPT_DIR/bin/start-vde.sh" "$TAPDEV"
sudo "$SCRIPT_DIR/bin/route-tap-to-gateway.sh" "$TAPDEV"
