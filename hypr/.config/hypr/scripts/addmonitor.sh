#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprland/monitors.conf"

hyprctl -j monitors | jq -c '.[]' | while read -r monitor_data; do
    description=$(echo "$monitor_data" | jq -r '.description')

    # Check if the description already exists in the config file
    if ! grep -q "desc:${description}" "$CONFIG_FILE"; then
        width=$(echo "$monitor_data" | jq -r '.width')
        height=$(echo "$monitor_data" | jq -r '.height')
        refresh_rate=$(echo "$monitor_data" | jq -r '.refreshRate')
        x=$(echo "$monitor_data" | jq -r '.x')
        y=$(echo "$monitor_data" | jq -r '.y')
        scale=$(echo "$monitor_data" | jq -r '.scale')

        # Format and append the new monitor line
        formatted_refresh_rate=$(printf "%.2f" "$refresh_rate")
        formatted_scale=$(printf "%.1f" "$scale")

        echo "monitor = desc:${description}, ${width}x${height}@${formatted_refresh_rate}Hz, ${x}x${y}, ${formatted_scale}" >> "$CONFIG_FILE"
    fi
done
