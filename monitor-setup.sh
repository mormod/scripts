#!/bin/bash

swaymsg output eDP-1 scale 1.5

GETOUTPUTS=$(swaymsg -t get_outputs)

if [[ $(swaymsg -t get_outputs | grep -w DP-1) ]]; then
	# this is the monitor at my desk at home
	notify-send "DP-1 connected" "Configuring it to be the main monitor"
	swaymsg output DP-1 scale 1.3333333
	swaymsg output DP-1 mode 2560x1440 pos 0 0
    # suck it, two monitor setup
	swaymsg output eDP-1 disable
fi

if [[ $(swaymsg -t get_outputs | grep -w HDMI-A-1) ]] && [[ $(swaymsg -t get_outputs | grep -w H9XZ401605) ]]; then
	# this is the monitor in the chairs schlauchraum
    # and apparently the same one my mother has at home. nice
	notify-send "HDMI-A-1 connected" "Configuring it to be the main monitor"
	swaymsg output HDMI-A-1 mode 1920x1200 pos 0 0
	swaymsg output eDP-1 mode 2560x1440 pos 1920 0 scale 2
fi
