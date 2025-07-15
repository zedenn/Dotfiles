#!/usr/bin/env bash
set -euo pipefail

# Internal panel
INT_PANEL="eDP-1"

# Runtime & hypr dir
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPR_DIR="$RUNTIME_DIR/hypr"

# 1) If signature is set, look for that exact .sock
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE-}" ]]; then
  SOCK="$HYPR_DIR/${HYPRLAND_INSTANCE_SIGNATURE}.socket2.sock"
else
  # 2) Otherwise pick any .sock in the hypr dir
  SOCK=$(find "$HYPR_DIR" -maxdepth 1 -type s | head -n1 || true)
fi

# 3) Bail if no socket found
if [[ ! -S "$SOCK" ]]; then
  echo "ERROR: Cannot find any Hyprland socket in $HYPR_DIR" >&2
  exit 1
fi

echo "→ Using Hyprland socket: $SOCK"

# Helper functions
get_lid_state() {
  awk '{print tolower($2)}' /proc/acpi/button/lid/*/state
}
toggle_internal() {
  hyprctl dispatch dpms "$INT_PANEL" "$1"
}

# Initial DPMS on startup
if [[ "$(get_lid_state)" == "closed" ]]; then
  toggle_internal off
else
  toggle_internal on
fi

#  Start listening for lid events
udevadm monitor --udev --subsystem-match=input |
while read -r line; do
  if grep -q 'button/lid' <<<"$line"; then
    if [[ "$(get_lid_state)" == "closed" ]]; then
      toggle_internal off
    else
      toggle_internal on
    fi
  fi
done &

# Listen for Hyprland monitorAdded/monitorRemoved
socat -t0 - UNIX-CONNECT:"$SOCK" \
  | jq -cr 'select(.type=="monitorAdded" or .type=="monitorRemoved")' \
  | while read -r ev; do
      type=$(jq -r '.type' <<<"$ev")
      if [[ "$type" == "monitorAdded" ]]; then
        name=$(jq -r '.monitor.name' <<<"$ev")
        hyprctl dispatch dpms "$name" on
      else
        name=$(jq -r '.name' <<<"$ev")
        hyprctl dispatch dpms "$name" off
      fi
    done &

wait
