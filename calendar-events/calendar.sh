#!/bin/bash

#------- 情報の取得 ---------#
IFS=$'\n'
todayTitles=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "" -iep "title" eventsToday))
todayTimes=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "" -iep "datetime" eventsToday))
tomorrowTitles=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b "" -iep "title" eventsFrom:tomorrow to:tomorrow))
tomorrowTimes=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b "" -iep "datetime" eventsFrom:tomorrow to:tomorrow))
IFS=$'|'
todayLocations=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -n -nc -b "|" -iep "title,location" eventsToday))
tomorrowLocations=($(/usr/local/bin/icalBuddy -ec "特定日サービス" -eep "attendees" -nc -n -b '|' -iep "title,location" eventsFrom:tomorrow to:tomorrow))

#---------- 表示 ------------#
echo
echo " TODAY"
echo " ==========================="

for i in ${!todayTitles[@]}
do
		location=$(echo ${todayLocations[$((i+1))]} | grep "location: " | sed -e "s/.*location: //")
		if [ -n "$location" ]
			then echo " ${todayTimes[$i]}＠$location"
			else echo " ${todayTimes[$i]}"
		fi
		echo "　${todayTitles[$i]}"
		echo
done

echo
echo " TOMORROW"
echo " ==========================="

tomorrowCnt=${#todayTitles[@]}
while (( $tomorrowCnt < ${#tomorrowTitles[@]} ))
do
		time=${tomorrowTimes[$tomorrowCnt]/tomorrow at /}
		location=$(echo ${tomorrowLocations[$((tomorrowCnt+1))]} | grep "location: " | sed -e "s/.*location: //")
		if [ -n "$location" ]
			then echo " ${time}＠$location"
			else echo " $time"
		fi
		echo "　${tomorrowTitles[$tomorrowCnt]}"
		echo
		((tomorrowCnt++))
done
