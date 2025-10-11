#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/scripts/monitorstate.conf"
INTERNAL_MONITOR="eDP-1"

# Check if the lid is closed
if grep -q closed /proc/acpi/button/lid/LID*/state; then
    # Check if external monitor is connected
    if hyprctl monitors | grep 'Monitor' | grep -v "$INTERNAL_MONITOR"; then
        # External monitor is connected, disable internal monitor
        echo "monitor = $INTERNAL_MONITOR, disable" > "$CONFIG_FILE"
        echo "THIS MEANS THAT THE SCRIPT WAS RUN WHEN EXTERNAL DISPLAY WAS CONNECTED" > /home/zeden/hyprmonitor.txt
    else
        # No external monitor, turn off internal monitor
        hyprctl dispatch dpms off $INTERNAL_MONITOR
    fi
else
    # Lid is open, clear the file
    echo "" > "$CONFIG_FILE"
    hyprctl dispatch dpms on $INTERNAL_MONITOR
fi
