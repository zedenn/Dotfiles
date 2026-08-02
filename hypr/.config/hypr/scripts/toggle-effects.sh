#!/bin/bash
COMMAND=$1
ACTION=$2

# Function to read and format the current state directly from Hyprland
print_status() {
    local cmd=$1
    local current_raw

    case "$cmd" in
        blur)
            current_raw=$(hyprctl getoption decoration:blur:enabled | grep "int:")
            if [[ "$current_raw" == *"int: 1"* ]]; then
                echo -e "Hyprland: Visual blur is currently \e[32mon\e[0m"
            else
                echo -e "Hyprland: Visual blur is currently \e[31moff\e[0m"
            fi
            ;;
        shadow)
            current_raw=$(hyprctl getoption decoration:shadow:enabled | grep "int:")
            if [[ "$current_raw" == *"int: 1"* ]]; then
                echo -e "Hyprland: Window shadows are currently \e[32mon\e[0m"
            else
                echo -e "Hyprland: Window shadows are currently \e[31moff\e[0m"
            fi
            ;;
        vfr)
            current_raw=$(hyprctl getoption debug:vfr | grep "int:")
            if [[ "$current_raw" == *"int: 1"* ]]; then
                echo -e "Hyprland: VFR is currently \e[32mon\e[0m (Saving GPU cycles)"
            else
                echo -e "Hyprland: VFR is currently \e[31moff\e[0m (Max performance / Constant Redraw)"
            fi
            ;;
    esac
}

# 1. PURE STATUS CHECK: If no action (on/off) is passed, just read the state and exit
if [ -z "$ACTION" ]; then
    print_status "$COMMAND"
    exit 0
fi

# 2. EXECUTE CHANGE: If an action was provided, validate and translate it for Lua
if [ "$ACTION" == "on" ]; then
    VALUE="true"
    COLOR_STATE="\e[32mon\e[0m"
elif [ "$ACTION" == "off" ]; then
    VALUE="false"
    COLOR_STATE="\e[31moff\e[0m"
else
    echo "Usage: $0 {blur|shadow|vfr} [on|off]"
    exit 1
fi

case "$COMMAND" in
    blur)
        hyprctl eval "hl.config({ decoration = { blur = { enabled = $VALUE } } })" > /dev/null
        echo -e "Hyprland: Visual blur changed to $COLOR_STATE"
        ;;
    shadow)
        hyprctl eval "hl.config({ decoration = { shadow = { enabled = $VALUE } } })" > /dev/null
        echo -e "Hyprland: Window shadows changed to $COLOR_STATE"
        ;;
    vfr)
        hyprctl eval "hl.config({ debug = { vfr = $VALUE } })" > /dev/null
        if [ "$ACTION" == "on" ]; then
            echo -e "Hyprland: VFR changed to $COLOR_STATE (Saving GPU cycles)"
        else
            echo -e "Hyprland: VFR changed to $COLOR_STATE (Max performance / Constant Redraw)"
        fi
        ;;
    *)
        echo "Usage: $0 {blur|shadow|vfr} [on|off]"
        exit 1
        ;;
esac
