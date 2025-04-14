#!/bin/sh

handle() {
  case $1 in
    monitoradded*) ~/.scripts/hyprland_clamshell.sh;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
