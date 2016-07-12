#!/bin/bash

# Author: David Genesis Cruz（https://github.com/davidgenesiscruz）
# Created: 2016/03/23
#
# Displays Today's and Tomorrow's events in the following format:
# 
# TODAY
# ==================================
# 10:00 - 11:00
# 　Dance practice
# 
# 11:00 - 12:00 @ Central Park
# 　Yoga
#
#
# TOMORROW
# ==================================
# 9:30 - 13:00
# 　Gym
#
# 13:00 - 14:00 @ Tiffany's
# 　Lunchdate

#--------- Helper -----------#
function displayEvents {
	noEvents=true
	for cnt in "${!timestamps[@]}"
	do
		if [[ "${timestamps[$cnt]}" == "\$$1"* ]]
		then
			if [ "$noEvents" = true ]
				then noEvents=false
			fi
			timestamp=$(echo ${timestamps[$cnt]} | cut -d$ -f2)
			title=$(echo ${titles[$cnt]} | cut -d$ -f2)
			location=""
			if [[ ${locations[$cnt]} =~ "location" ]]
				then location=$(echo ${locations[$cnt]} | cut -d$ -f2 | cut -d: -f2-)
			fi
		
			if [[ "$timestamp" == "$1" || "$timestamp" == "$1 - "* ]] # All day events
			then
				if [ -n "$location" ]
					then echo " 《《 $title @ $location 》》"
					else echo " 《《 $title 》》"
				fi 
			else
				if [ -n "$location" ]
					then echo " ${timestamp/$1 at /} ＠ $location"
					else echo " ${timestamp/$1 at /}"
				fi
				echo "　$title"
			fi
			echo
		fi
	done

	if [ "$noEvents" = true ]
	then
		echo "no events $1"
	fi
}

#------- 情報の取得 ---------#
IFS=$'\n'
remCals="特定日サービス,52C6D8C2-7AE9-45FE-ADDC-1123075207AF,キャリトレ監視カレンダー"
timestamps=($(/usr/local/bin/icalBuddy -ec "$remCals" -eep "attendees" -n -nc -b "$" -iep "datetime" eventsToday+1))
titles=($(/usr/local/bin/icalBuddy -ec "$remCals" -eep "attendees" -n -nc -b "$" -ps "|\$|" -iep "datetime,title" eventsToday+1))
locations=($(/usr/local/bin/icalBuddy -ec "$remCals" -eep "attendees" -n -nc -b "$" -ps "|\$|" -iep "datetime,location" eventsToday+1))
IFS=$' '
weatherUrl="http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c"
weatherForecastLow=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f6)
weatherForecastHigh=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f8)
weatherForecastCondition=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f10)
cnt=0

#---------- 表示 ------------#
echo
echo " TODAY"
echo " ==========================="
displayEvents "today"
echo
echo " TOMORROW"
echo " $weatherForecastCondition ($weatherForecastLow ~ $weatherForecastHigh ℃)"
echo " ==========================="
displayEvents "tomorrow"
