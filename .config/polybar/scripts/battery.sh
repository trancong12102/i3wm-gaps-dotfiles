#!/usr/bin/bash

## created by nopain

STATE_CONF=~/.config/polybar/scripts/battery.conf
. $STATE_CONF

if [[ $1 == "r" ]];
then
	echo "prv_state=normal" > $STATE_CONF
	exit 0
fi

AC="/sys/class/power_supply/AC/uevent"
SUP_ONL="POWER_SUPPLY_ONLINE="

BAT0="/sys/class/power_supply/BAT0/uevent"
BAT1="/sys/class/power_supply/BAT1/uevent"
ENE_NOW="POWER_SUPPLY_ENERGY_NOW="
ENE_FULL="POWER_SUPPLY_ENERGY_FULL="

PER_FULL=98
PER_LOW=25
PER_CRIT=10

get_ene() {
	now=$(grep $ENE_NOW $1 | grep -o -E "[0-9]+")
	full=$(grep $ENE_FULL $1 | grep -o -E "[0-9]+")
	return $((now * 100 / full))
}

get_ac() {
	ac=$(grep $SUP_ONL $AC | grep -o -E "[0-9]+")
}

get_ene $BAT0
bat0=$?

get_ene $BAT1
bat1=$?

get_ac

bat=$(( (bat0 + bat1) / 2 ))

icon=""
color="#6a89cc"

if [ $bat -lt 10 ];
then
	icon=""
	color="#eb4d4b"
elif [ $bat -lt 20 ];
then
	icon=""
	color="#eb4d4b"
elif [ $bat -lt 45 ];
then
	icon=""
elif [ $bat -lt 70 ];
then
	icon=""
elif [ $bat -lt 95 ];
then
	icon=""
fi

state="normal"

if [ $bat -lt 10 ];
then
	state="critical"
elif [ $bat -lt 20 ];
then
	state="low"
fi

if [ $ac -eq 1 ];
then
	icon=""
	color="#4cd137"
	state="charging"
fi

if [ $bat -gt 98 ];
then
	state="full"
fi

if [[ $state != $prv_state ]];
then
	title=""
	mess=""
	urgency="critical"

	if [[ $state == "low" ]];
	then
		title="Your battery is running low ($bat%)"
		mess="You might want to plugin your PC"
	elif [[ $state == "critical" ]];
	then
		title="Laptop battery critically low ($bat%)"
		mess="Computer will hibernate very soon unless it is plugged in"
	elif [[ $state == "full" ]];
	then
		if [ $ac -eq 1 ];
		then
			title="Laptop battery is fully charged"
			mess="Please unplugging"
			urgency="normal"
		fi
	fi

	if [[ $title != "" ]];
	then
		notify-send "$title" "$mess" -u $urgency
	fi
fi

echo "%{F$color}$icon%{F-} BAT: $bat%"

echo "prv_state=$state" > $STATE_CONF


