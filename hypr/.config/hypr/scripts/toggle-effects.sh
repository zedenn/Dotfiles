#!/bin/bash
COMMAND=$1
ACTION=$2

if [ "$ACTION" == "on" ]; then
    VALUE="true"
else
    VALUE="false"
fi

case "$COMMAND" in
    blur)
        hyprctl keyword decoration:blur:enabled "$VALUE"
        ;;
    shadow)
        # Correct path for shadows in Hyprland
        hyprctl keyword decoration:shadow:enabled "$VALUE"
        ;;
    vfr)
        # Note: vfr on = true (saves GPU), vfr off = false (high usage)
        hyprctl keyword misc:vfr "$VALUE"
        ;;
    *)
        echo "Usage: blur|shadow|vfr {on|off}"
        exit 1
        ;;
esac
