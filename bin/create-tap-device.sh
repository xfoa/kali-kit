#!/bin/bash

# Based on code from the answer to this question on Stack Exchange:
# https://unix.stackexchange.com/questions/724542/86box-on-linux-slackware-how-to-enable-networking-with-pcap

# Exit at first error
set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/../lib/helpers.sh"
readonly DEPS=(ip grep awk cut sed sort tail)
check_deps DEPS

# Run this as root
if [ $UID != "0" ]
then
echo "Run this script as root" >&2
exit 1
fi

show_usage() {
	cat << EOF >&2
$(basename "$0") [--help|-h] [--tap-name|-n NAME] [--bridge|-b BRIDGE] USER
Create a tun/tap device a the next available number.

	--help | -h		Display this usage message.
	--tap-name | -n NAME	Base name of the TAP device to create, without a number at the end. Defaults to 'tap'.
	--bridge| -b BRIDGE 	Connect TAP interface to bridge named BRIDGE (e.g. br0), which must already exist. Note:
                                bridges can't usually be used with WiFi interfaces.
        --tap-ip | -i IP	Specify an IP (with subnet prefix length) the TAP interface will use. Defaults to '10.1.0.1/16'.
	USER			Username to create TAP device for.
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
		--bridge|-b)
			readonly BRIDGE="${2:?No bridge name supplied}"
			shift
			shift
			;;
		--ip|-i)
			readonly TAP_IP_GIVEN="${2:?No IP supplied}"
			shift
			shift
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

# Other vars
readonly USER="${1:?No user name supplied}"
readonly TAP_NAME="${TAP_NAME_GIVEN:-tap}"
readonly TAP_IP="${TAP_IP_GIVEN:-10.1.0.1/16}"

# Increment tap device number
readonly TAP="$(ip link show type tun | grep $TAP_NAME | awk '{print $2}' | cut -d : -f 1 | sed s/^$TAP_NAME// | sort | tail -1)"
readonly TAPDEV="$TAP_NAME$((${TAP:--1}+1))"

# Create TAP for user
ip tuntap add dev "$TAPDEV" mode tap user "$USER"
ip link set "$TAPDEV" up promisc on
ip link set "$TAPDEV" ${BRIDGE:+master "$BRIDGE"}
ip a add "$TAP_IP" dev "$TAPDEV"
echo "TAP device $TAPDEV for user $USER ${BRIDGE:+, using bridge $BRIDGE}, with IP address $TAP_IP"
echo "To remove it use command 'ip link delete $TAPDEV' as root"
