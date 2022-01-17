#!/bin/bash

sep=' | '

while true; do
    output=""

    weather=$(curl -s 'wttr.in/?format=%l:+%C+%t')
    network_ssid=$(iwgetid -r)
    battery_life=$(cat /sys/class/power_supply/BAT0/capacity)
    battery_remaining_time=$(acpi | head -1 | awk '{ print $5 }')
    time=$(date +'%c')

    if [[ ! -z "$network_ssid" ]]; then
        output="${network_ssid}${sep}"
    fi

    if [[ ! -z "$weather" ]]; then
        output="${output}${weather}${sep}"
    fi

    # Fixes problem with acpi showing the battery state for the wrong battery
    if [[ "$battery_remaining" = "rate" ]]; then
        battery_remaining_time=$(acpi | sed -n 2p | awk '{ print $5 }')
    fi

    battery_charging_indicator=""
    if [[ $(acpi -b | head -1 | grep Charging) ]]; then
        battery_charging_indicator="⇧ "
    elif [[ $(acpi -b | head -1 | grep Discharging) ]]; then
        battery_charging_indicator="⇩ "
    fi

    output="${output}${battery_charging_indicator}${battery_life}%"

    # If laptop is fully charged and connected to power outlet, there is nothing to
    # display, so only display if not empty
    if [[ ! -z "$battery_remaining_time" ]]; then
        output="${output} (${battery_remaining_time})"
    fi

    output="${output}${sep}"

    echo "${output}${time}${sep}"
    sleep 1;
done
