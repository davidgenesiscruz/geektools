#!/bin/bash

# Author: David Genesis Cruz（https://github.com/davidgenesiscruz）
# Created: 2015/04/17
#
# Acquires concise weather condition information from Yahoo! Weather

url="http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c"
curl -s "$url" | grep 'condition' | cut -d\" -f2
