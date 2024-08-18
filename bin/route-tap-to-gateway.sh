#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source "$SCRIPT_DIR/../lib/helpers.sh"
readonly DEPS=(ip sysctl iptables grep tr cut)
check_deps DEPS

# Run this as root
if [ $UID != "0" ]
then
echo "Run this script as root"
exit 1
fi

show_usage() {
	cat << EOF >&2
$(basename "$0") [--help|-h] TAP_DEVICE GATEWAY_INTERFACE
Route traffic to the internet from a TAP device via another interface.

	TAP_DEVICE		Interface name of the TAP device to connect to VDE.
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

# Set vars
readonly TAPDEV="${1:?TAP device not specified}"
readonly TAP_IP="$(ip a show dev "$TAPDEV" | grep inet | grep -v inet6 | tr -s ' ' | cut -d' ' -f 3)"
readonly GATEWAY_IF="$(ip route | grep default | tr -s ' ' | cut -d ' ' -f 5)"
readonly DEFAULT_GW="$(ip route | grep default | tr -s ' ' | cut -d ' ' -f 3)"
readonly MASQ_IP="$(ip a show dev wlp0s20f3 | grep inet | grep -v inet6 | tr -s ' ' | cut -d' ' -f 3 | cut -d '/' -f1)"

# Make sure TAP exists
ip link show "$TAP_DEVICE" > /dev/null
readonly TAP_FOUND="$?"
if [[ ! $TAP_FOUND ]]
then
	echo "TAP device $TAP_DEVICE doesn't exist in dev. Create it by running 'create-tap-device.sh'" >&2
	exit 1
fi

# Set up routing
sysctl -w net.ipv4.ip_forward=1 > /dev/null
iptables -t nat -A POSTROUTING -s 10.1.0.1/16 -o "$GATEWAY_IF" -j MASQUERADE
iptables -A FORWARD -i "$GATEWAY_IF" -o "$TAPDEV" -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i "$TAPDEV" -o "$GATEWAY_IF" -j ACCEPT

echo "Routing has been set up between $TAPDEV and $GATEWAY_IF."
echo "Traffic from $TAP_IP will be masqueraded as $MASQ_IP."
echo "The default gateway in the VM needs to be set to $DEFAULT_GW."