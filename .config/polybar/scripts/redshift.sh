#!/bin/sh

## Created by nopain2110

apply_temp() {
	
	if [ $on == 1 ];
	then
		redshift -P -O $cur_temp
	fi
}

reset_temp() {
	redshift -x
}

toggle() {
	if [ $on == 0 ];
	then
		on=1
	else
		on=0
		reset_temp
	fi
}

increase() {
	on=1

	if (( cur_temp < 8500 ));
	then
		let "cur_temp+=50"
	fi
}

decrease() {
	on=1

	if (( cur_temp > 50 ));
	then
		let "cur_temp-=50"
	fi
}

print() {
	if [ $on == 0 ];
	then
		echo "%{F#757575} OFF"
	else
		echo "%{F#ff8f00}%{F-} $cur_temp K"
	fi
}

conf_file=/home/nopain2110/.config/polybar/scripts/redshift.conf
. $conf_file

mode=$1

apply_temp


if [ $mode == "p" ]; 
then 
	print
fi

if [ $mode == "t" ];
then
	toggle
fi

if [ $mode == "u" ];
then
	increase
fi

if [ $mode == "d" ];
then
	decrease
fi

cat <<EOM >$conf_file
cur_temp=$cur_temp
on=$on
EOM