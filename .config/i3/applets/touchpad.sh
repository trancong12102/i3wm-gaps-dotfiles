#!/usr/bin/bash

## created by nopain2110
## auto disable touchpad when mouse plugged 
## enable touchpad when mouse unplugged

while :
do
	xinput list | grep -iq mouse && synclient TouchpadOff=1 || synclient TouchpadOff=0
	sleep 1
done

