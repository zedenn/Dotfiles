#!/bin/bash
# If lid is closed, this script writes hyprland valid syntax to monitorstate.conf for disabling internal laptop screen. If lid is open, the file is cleared.
# INSTRUCTIONS:
# 1) Source the $CONFIG_FILE in your hyprland.conf
# 2) exec-once this script in your hyprland.conf (disables laptop screen on startup, if lid is closed)
# 3) Add bindl switches for this script in hyprland.conf (disables or enables laptop screen, if lid switches state)
    # bindl=,switch:on:Lid Switch,exec,~/.config/hypr/scripts/clamshell.sh
    # bindl=,switch:off:Lid Switch,exec,~/.config/hypr/scripts/clamshell.sh

CONFIG_FILE="$HOME/.config/hypr/scripts/monitorstate.conf"
INTERNAL_MONITOR="eDP-1"

# Check if the lid is closed
if grep -q closed /proc/acpi/button/lid/LID*/state; then
    # If closed, explicitly disable the internal monitor
    echo "monitor = $INTERNAL_MONITOR, disable" > "$CONFIG_FILE"
else
    # If open, clear the file to allow the screen to be used
    echo "" > "$CONFIG_FILE"
fi
