#!/usr/bin/bash

## created by nopain


declare -A bat_per=() bat_stat=()

get_bat() {
	e_now=$(grep -E "^POWER_SUPPLY_ENERGY_NOW=[0-9]+" "/sys/class/power_supply/BAT$1/uevent" | grep -o -E "[0-9]+")
	e_full=$(grep -E "^POWER_SUPPLY_ENERGY_FULL=[0-9]+" "/sys/class/power_supply/BAT$1/uevent" | grep -o -E "[0-9]+")
	stat=$(grep -E "^POWER_SUPPLY_STATUS=" "/sys/class/power_supply/BAT$1/uevent" | grep -o -E "Charging|Unknown|Discharging|Full")

	bat_per[$1]=$(( $e_now * 100 / $e_full ))
	bat_stat[$1]=$stat
}

bat_man() {
	get_bat 0
	get_bat 1

	bat0_per=${bat_per[0]} 
	bat0_stat=${bat_stat[0]}

	bat1_per=${bat_per[1]} 
	bat1_stat=${bat_stat[1]}

	bat_per=$(( ($bat0_per + $bat1_per) / 2 ))

	if [ $bat_per -lt 25 ];
	then
		stat0=$(echo $bat0_stat | grep -o -E "Charging")
		stat1=$(echo $bat1_stat | grep -o -E "Charging")
	
		if [[ $stat0 == "Charging" || $stat1 == "Charging" ]];
		then
			low_notice=0
		else
			if [ $low_notice -eq 0 ];
			then
				notify-send "Battery is low" "Please charging!" -u critical
				low_notice=1
			fi

		fi

	else
		low_notice=0
	fi

	if [ $bat_per -gt 96 ];
	then
		stat0=$(echo $bat0_stat | grep -o -E "Charging")
		stat1=$(echo $bat1_stat | grep -o -E "Charging")
	
		if [[ $stat0 == "Charging" || $stat1 == "Charging" ]];
		then
			if [ $full_notice -eq 0 ];
			then
				notify-send "Battery is full" "Please discharging!" -u critical
				full_notice=1
			fi

		else
			full_notice=0
		fi

	else
		full_notice=0
	fi

}

low_notice=0
full_notice=0

while :
do
	bat_man
	sleep 1
done
