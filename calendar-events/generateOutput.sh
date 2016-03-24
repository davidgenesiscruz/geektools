#!/bin/bash

# Author: David Genesis Cruz（https://github.com/davidgenesiscruz）
# Created: 2016/03/23

# Utility script for calendar.sh
# Outputs to a temporary file to be switched with the actual output file

function usage {
	echo "Usage: $0 filepath"
	echo
	echo "filepath - specifies the path where calendar.sh is located"
	echo "           it is also the path where .output will be saved"
	echo
	exit 1
}

if [ $# != 1 ]
	then usage
fi

path="$1"
src="calendar.sh"
output=".output"
tmp=".output.tmp"

cd "$path"
if [ ! -f "$output" ]
	then touch "$output"
fi

"$path$src" > "$tmp"
mv -f "$tmp" "$output"
