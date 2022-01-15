#!/bin/bash

sep=' | '

while true; do
	output=""
	weather=$(curl -s 'wttr.in/?format=%l:+%C+%t')
	network_ssid=$(iwgetid -r)
	battery_life=$(cat /sys/class/power_supply/BAT0/capacity)
	battery_remaining=$(acpi | head -1 | awk '{ print $5 }')
	time=$(date +'%c')
	
	if [[ ! -z "$network_ssid" ]]; then
		output="${network_ssid}${sep}"
	fi
	
	if [[ ! -z "$weather" ]]; then
		output="${output}${weather}${sep}"
	fi
	
	# Fixes problem with acpi showing the battery state for the wrong battery
	if [[ "$battery_remaining" = "rate" ]]; then
		battery_remaining=$(acpi | sed -n 2p | awk '{ print $5 }')
	fi

	echo "${output}${battery_life}% (${battery_remaining})${sep}${time}${sep}"
	sleep 1;	
done
