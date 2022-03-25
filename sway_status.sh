#!/bin/bash

#sep='\e[1;90m | \e[0m'
sep=' | '

while true; do
    output=""

    weather=$(curl -s 'wttr.in/?format=%l:+%C+%t')
    network_ssid=$(iwgetid -r)
    battery_life=$(cat /sys/class/power_supply/BAT0/capacity)
    battery_remaining_time=$(acpi | head -1 | awk '{ print $5 }')
    battery_status=$(acpi | head -1 | awk '{ print $3 }')
    time=$(date +'%c')

    if [[ ! -z "$network_ssid" ]]; then
        output="${network_ssid}${sep}"
        if [[ ! -z "$weather" ]] & [[ ! "$(echo $weather | awk '{ print $1 }')" = "Unknown" ]]; then
            output="${output}${weather}${sep}"
        fi
    fi


    # Fixes problem with acpi showing the battery state for the wrong battery
    if [[ "$battery_remaining_time" = "rate" ]]; then
        battery_remaining_time=$(acpi | sed -n 2p | awk '{ print $5 }')
        battery_status=$(acpi | sed -n 2p | awk '{ print $3 }')
    fi

    battery_charging_indicator="⇨ "
    if [[ $(echo $battery_status | grep Charging) ]]; then
        battery_charging_indicator="⇧ "
    elif [[ $(echo $battery_status | grep Discharging) ]]; then
        battery_charging_indicator="⇩ "
    fi

    output="${output}${battery_charging_indicator}${battery_life}%"

    # If laptop is fully charged and connected to power outlet, there is nothing to
    # display, so only display if not empty
    if [[ ! -z "$battery_remaining_time" ]]; then
        output="${output} (${battery_remaining_time})"
    fi

    # This makes sure, that an output just consisting of spaces is ignored
    if [[ ! -z $(echo "${output}") ]]; then
        output="${output}${sep}"
    fi

    echo -e "${output}${time}${sep}"
    sleep 1;
done
