#!/bin/bash

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
