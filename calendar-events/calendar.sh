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

#------- 情報の取得 ---------#
IFS=$'\n'
timestamps=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "$" -iep "datetime" eventsToday+1))
titles=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "$" -ps "|\$|" -iep "datetime,title" eventsToday+1))
locations=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "$" -ps "|\$|" -iep "datetime,locations" eventsToday+1))
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

while [[ "${timestamps[$cnt]}" == "\$today"* ]]
do
	timestamp=$(echo ${timestamps[$cnt]} | cut -d$ -f2)
	title=$(echo ${titles[$cnt]} | cut -d$ -f2)
	location=$(echo ${locations[$cnt]} | cut -d$ -f3)

	if [ "$timestamp" != "today" ]
	then
		if [ -n "$location" ]
			then echo " ${timestamp/today at /} ＠ $location"
			else echo " ${timestamp/today at /}"
		fi
		echo "　$title"
	else # All day events
		if [ -n "$location" ]
			then echo " 《《 $title @ $location 》》"
			else echo " 《《 $title 》》"
		fi 
	fi
	echo
	((cnt++))
done

echo
echo " TOMORROW"
echo " $weatherForecastCondition ($weatherForecastLow ~ $weatherForecastHigh ℃)"
echo " ==========================="

while [[ "${timestamps[$cnt]}" == "\$tomorrow"* ]]
do
	timestamp=$(echo ${timestamps[$cnt]} | cut -d$ -f2)
	title=$(echo ${titles[$cnt]} | cut -d$ -f2)
	location=$(echo ${locations[$cnt]} | cut -d$ -f3)

	if [ "$timestamps" != "tomorrow" ]
	then
		if [ -n "$location" ]
			then echo " ${timestamp/tomorrow at /} ＠ $location"
			else echo " ${timestamp/tomorrow at /}"
		fi
		echo "　$title"
	else # All day events
		if [ -n "$location" ]
			then echo " 《《 $title @ $location 》》"
			else echo " 《《 $title 》》"
		fi 
	fi
	echo
	((cnt++))
done
