#!/bin/bash

# Author: David Genesis Cruz（https://github.com/davidgenesiscruz）
# Created: 2015/04/17
#
# Acquires weather icon from Yahoo! Weather

function usage {
	echo "Usage: getIcon.sh filename"
	echo
	echo "filename - filename with which the icon would be saved"
	echo
	exit 1
}

if [ $# != 1 ]
	then usage
fi

url="http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c"

icon=$(curl -s "$url" | grep 'src' | cut -d\" -f2)
curl -s "$icon" -o "$1"
