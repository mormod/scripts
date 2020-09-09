#!/bin/bash

if [[ $(xrandr | grep -w 'connected' | wc -l) -eq 2 ]] && [[ $(xrandr | grep '*+' | wc -l) -ne 2 ]] 
then
	if [ $(xrandr | grep 'HDMI1 connected' | wc -l) -eq 1 ] 
	then
		if [ $(xrandr | grep 'HDMI1 connected' | grep '1920x1200' | wc -l) -gt 1 ]
		then
			xrandr --output eDP1 --auto --output HDMI1 --mode 1920x1200 --scale 1.333333333x1.2 --right-of eDP1
		else
			xrandr --output eDP1 --auto --output HDMI1 --mode 1920x1080 --scale 1.333333333x1.333333333 --right-of eDP1
		fi
	else
		xrandr | grep -w 'DP1 connected' && xrandr --output eDP1 --auto --output DP1 --mode 2560x1440 --right-of eDP1
	fi
else 
	xrandr --output eDP1 --auto --output HDMI1 --off
	xrandr --output eDP1 --auto --output DP1 --off

fi

