#!/bin/bash

set -eu

check_deps() {
	local -rn deps=${1?No dependencies supplied!}
	local not_found=()
	for dep in "${deps[@]}"
	do
		set +e
		which "$dep" > /dev/null
		rc="$?"
		set -e
		if [[ "$rc" == 1 ]]
		then
			not_found+=("$dep")
		fi
	done

	if [[ "${#not_found[@]}" > 0 ]]
	then
		echo "Error: The following commands are dependencies of this script but were not found:" >&2
		for dep in "${not_found[@]}"
		do
			echo "  $dep" >&2
		done
		echo -e "\nPlease make sure these are installed, in a directory in PATH, and executable." >&2
		exit 1
	fi
}
