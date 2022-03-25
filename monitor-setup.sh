#!/bin/bash

swaymsg output eDP-1 scale 1.5

if [[ $(swaymsg -t get_outputs | grep -w DP-1) ]]; then
	notify-send "DP-1 connected" "Configuring it to be the main monitor"
	swaymsg workspace 1 output DP-1
  swaymsg output DP-1 scale 1.3333333
	swaymsg output DP-1 mode 2560x1440 pos 0 0
	swaymsg output eDP-1 mode 2560x1440 pos 1920 0
else
	swaymsg workspace 1 output eDP-1
fi

