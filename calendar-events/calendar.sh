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
todayTitles=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "" -iep "title" eventsToday))
todayTimes=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "" -iep "datetime" eventsToday))
tomorrowTitles=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b "" -iep "title" eventsFrom:tomorrow to:tomorrow))
tomorrowTimes=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b "" -iep "datetime" eventsFrom:tomorrow to:tomorrow))
IFS=$'|'
todayLocations=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "|" -iep "title,location" eventsToday))
tomorrowLocations=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b '|' -iep "title,location" eventsFrom:tomorrow to:tomorrow))
weatherUrl="http://xml.weather.yahoo.com/forecastrss?p=JAXX0085&u=c"
weatherForecastLow=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f6)
weatherForecastHigh=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f8)
weatherForecastCondition=$(curl -s "$weatherUrl" | grep "forecast" | head -n5 | tail -n1 | cut -d'"' -f10)

#---------- 表示 ------------#
echo
echo " TODAY"
echo " ==========================="

for i in ${!todayTitles[@]}
do
		location=$(echo ${todayLocations[$((i+1))]} | grep "location: " | sed -e "s/.*location: //")
		if [ "${todayTimes[$i]}" != "today" ]
		then
			if [ -n "$location" ]
				then echo " ${todayTimes[$i]} ＠ $location"
				else echo " ${todayTimes[$i]}"
			fi
			echo "　${todayTitles[$i]}"
		else # All day events
			if [ -n "$location" ]
				then echo " 《《 ${todayTitles[$i]} @ $location 》》"
				else echo " 《《 ${todayTitles[$i]} 》》"
			fi 
		fi
		echo
done

echo
echo " TOMORROW"
echo " $weatherForecastCondition ($weatherForecastLow ~ $weatherForecastHigh ℃)"
echo " ==========================="

tomorrowCnt=${#todayTitles[@]}
while (( $tomorrowCnt < ${#tomorrowTitles[@]} ))
do
		time=${tomorrowTimes[$tomorrowCnt]/tomorrow at /}
		location=$(echo ${tomorrowLocations[$((tomorrowCnt+1))]} | grep "location: " | sed -e "s/.*location: //")
		if [ "$time" != "tomorrow" ]
		then
			if [ -n "$location" ]
				then echo " $time ＠ $location"
				else echo " $time"
			fi
			echo "　${tomorrowTitles[$tomorrowCnt]}"
		else # All day events
			if [ -n "$location" ]
				then echo " 《《 ${tomorrowTitles[$tomorrowCnt]} @ $location 》》"
				else echo " 《《 ${tomorrowTitles[$tomorrowCnt]} 》》"
			fi
		fi
		echo
		((tomorrowCnt++))
done
