#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/lua/monitorstate.lua"
INTERNAL_MONITOR="eDP-1"

# Check if the lid is closed
if grep -q closed /proc/acpi/button/lid/LID*/state; then
    # Check if external monitor is connected
    if hyprctl monitors | grep 'Monitor' | grep -v "$INTERNAL_MONITOR"; then
        # External monitor is connected, disable internal monitor using Lua API
        echo 'hl.monitor({ output = "'"$INTERNAL_MONITOR"'", disabled = true })' > "$CONFIG_FILE"
    else
        # No external monitor, turn off internal monitor via DPMS
        hyprctl dispatch dpms off "$INTERNAL_MONITOR"
    fi
else
    # Lid is open: Completely empty the file just like before
    echo "" > "$CONFIG_FILE"
    hyprctl dispatch dpms on "$INTERNAL_MONITOR"
fi
