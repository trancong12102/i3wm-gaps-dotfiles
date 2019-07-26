#!/usr/bin/bash

## Created by nopain

show() {
	## show current input method
	current=$(ibus engine)

	if [[ $current == "" ]];
	then
		exit 0
	fi

	if [[ $current == *"en"* ]];
	then
		current="%{F#9980FA}%{F-} EN"
	elif [[ $current == *"Bamboo"* ]];
	then
		current="%{F#ED4C67}%{F-} VI"
	else
		current="%{F#12CBC4}%{F-} $current"
	fi
	
	echo $current
}

switch() {
	## switch input method
	current=$(ibus engine)

	if [[ $current == *"Bamboo"* ]];
	then
		ibus engine xkb:us::eng
	else
		ibus engine Bamboo
	fi
}

if [[ $1 == "s" ]];
then
	switch
fi

show

