#!/bin/bash
# This script runs every time lid changes state and once on startup, triggered by hyprland.conf
#
# Conditions
# 1. If lid is closed & external monitor is connected, disable eDP-1
# 2. If lid is closed & external monitor is not connected, turn off eDP-1
# 3. If lid is open, enable or turn on eDP-1 depending on DPMS status
# Docs
# monitoradded>>DP*

# Checks lid state and count of active monitors
lidstate=$(cat /proc/acpi/button/lid/LID0/state | grep -o -E "open|closed")
monitorcount=$(hyprctl monitors | grep -c Monitor)

# 1. If lid is closed & external monitor is connected, disable eDP-1
if [ $lidstate = "closed" ] && [ $monitorcount = "2" ]; then
    hyprctl keyword monitor "eDP-1,disable"
fi

# 2. If lid is closed & external monitor is not connected, turn off eDP-1
if [ $lidstate = "closed" ] && [ $monitorcount = "1" ]; then
    activemonitor=$(hyprctl monitors | grep Monitor | awk '{print $2}')

    if [[ $activemonitor == "eDP"* ]]; then
    hyprctl dispatch dpms off eDP-1
    fi
fi

# 3. If lid is open, enable or turn on eDP-1 depending on DPMS status
if [ $lidstate = "open" ]; then
    dpmsstatus=$(hyprctl monitors | sed -n '/Monitor eDP-*/,/Monitor/p' | awk 'NR==13 {print $2}')

    if [ $dpmsstatus = "0" ]; then
        hyprctl dispatch dpms on eDP-1
    fi

    if ! hyprctl monitors | grep -q eDP ; then
        hyprctl keyword monitor "eDP-1,preferred,auto,1"
    fi
fi
