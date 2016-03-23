#!/bin/bash

# Author: David Genesis Cruz（https://github.com/davidgenesiscruz）
# Created: 2016/03/23

# Utility script for calendar.sh
# Outputs to a temporary file to be switched with the actual output file

path="/Users/david.genesis.cruz/Documents/dev/geektools/calendar-events/"
src="calendar.sh"
output=".output"
tmp=".output.tmp"

cd $path
if [ ! -f "$output" ]
	then touch "$output"
fi

$path$src > $tmp
mv -f $tmp $output
