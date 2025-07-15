#!/bin/bash

if [[ $(cat /proc/acpi/button/lid/LID/state | grep -o closed) = 'closed' ]]; then
    hyprctl keyword monitor "eDP-1,disable"
else
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
fi
