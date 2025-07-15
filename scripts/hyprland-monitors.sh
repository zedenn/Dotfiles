#!/usr/bin/env bash
set -euo pipefail

#—————————————————————————————
# CONFIGURATION
#—————————————————————————————
MON_PROFILES="$HOME/.config/hypr/monitors/profiles"
INTERNAL_RE='^(eDP|LVDS|edp|lvds)'

#—————————————————————————————
# Determine lid state (open or closed)
#—————————————————————————————
get_lid_state() {
  # 1) Look under /proc/acpi/button/lid/*/state
  for st in /proc/acpi/button/lid/*/state; do
    [[ -r $st ]] && { awk '{print $2}' "$st"; return; }
  done

  # 2) Fall back to `acpi -b` if installed
  if command -v acpi &>/dev/null; then
    acpi -b | awk '/Lid/ {print $3; exit}'
    return
  fi

  # 3) Give up and assume open
  printf 'open'
}

#—————————————————————————————
# INITIAL PASS: apply profiles based on current lid state
#—————————————————————————————
if [[ "${1:-}" == init ]]; then
  lid_state=$(get_lid_state)
  echo "[INIT] lid is $lid_state"

  # 1) Disable internal panels if lid is closed
  if [[ $lid_state == closed ]]; then
    echo "[INIT] disabling internal panel(s)"
    hyprctl -j monitors all \
      | jq -r '.[]
                 | select(.name|test("'"$INTERNAL_RE"'"))
                 | .name' \
      | while read -r name; do
          echo "[INIT] disable $name"
          hyprctl keyword monitor "$name,disable"
        done
  fi

  # 2) Apply profile for every currently enabled monitor
  #    (externals & internals if lid is open)
  echo "[INIT] applying profiles to all active monitors"
  hyprctl -j monitors all \
    | jq -r '.[]
               | select(.disabled == false)
               | .description' \
    | while read -r rawdesc; do
        # sanitize slug
        desc="${rawdesc,,}"
        desc="${desc// /_}"

        cfg="$MON_PROFILES/${desc}.conf"
        if [[ -f $cfg ]]; then
          echo "[INIT] apply $cfg"
          hyprctl keyword monitor "$( <"$cfg" )"
        else
          echo "[INIT] no profile for '$desc'"
        fi
      done

  # done with init → exit before launching the event loop
  exit 0
fi

#—————————————————————————————
# STATE
#—————————————————————————————
declare -A known_monitors   # monitor-name → handled?
declare -A seen_ids         # monitoraddedv2 ID → processed?
declare -A internal_desc    # internal-name → sanitized-description

#—————————————————————————————
# UTILITIES
#—————————————————————————————
sanitize() {
  local s="${1,,}"
  printf '%s' "${s// /_}"
}


apply_profile() {
  local desc="$1"
  local cfg="$MON_PROFILES/${desc}.conf"
  if [[ -f $cfg ]]; then
    local cmd
    cmd=$(<"$cfg")
    echo "[PROFILE] $desc → $cmd"
    hyprctl keyword monitor $cmd
  else
    echo "[PROFILE] no profile for '$desc'"
  fi
}

#—————————————————————————————
# SEED INITIAL STATE
#—————————————————————————————
# 1) Mark every currently active monitor as known
while IFS= read -r name; do
  known_monitors["$name"]=1
done < <(hyprctl -j monitors all | jq -r '.[].name')

# 2) Capture each internal panel’s sanitized description
while IFS=, read -r name raw; do
  name=${name//\"/}
  raw=${raw//\"/}
  internal_desc["$name"]="$(sanitize "$raw")"
done < <(
  hyprctl -j monitors all \
    | jq -r '.[]
               | select(.name | test("'"$INTERNAL_RE"'"))
               | [.name, .description]
               | @csv'
)

#—————————————————————————————
# LAUNCH LISTENERS AS COPROCESSES
#—————————————————————————————
coproc HYPR { socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"; }
coproc LID  { acpi_listen; }
HYPR_FD=${HYPR[0]} ; unset HYPR
LID_FD=${LID[0]}   ; unset LID

#—————————————————————————————
# MAIN EVENT LOOP
#—————————————————————————————
while true; do
  # 1) Handle lid events
  if read -t 0.05 -u "$LID_FD" lid_ev; then
    case "$lid_ev" in

      button/lid\ LID\ close)
        echo "[LID] close"
        # disable & forget all internals
        for name in "${!internal_desc[@]}"; do
          echo "[DISABLE] $name"
          hyprctl keyword monitor "$name,disable"
          unset 'known_monitors[$name]'
        done
        # clear past IPC IDs so next open is “fresh”
        seen_ids=()
        ;;

      button/lid\ LID\ open)
        echo "[LID] open"
        # immediately re-enable every internal panel
        for name in "${!internal_desc[@]}"; do
          apply_profile "${internal_desc[$name]}"
          known_monitors["$name"]=1
        done
        ;;
    esac
  fi

  # 2) Handle Hyprland IPC (new monitoraddedv2)
  if read -t 0.05 -u "$HYPR_FD" line; then
    [[ $line != monitoraddedv2\>* ]] && continue

    # parse → monitoraddedv2>>ID,NAME,DESCRIPTION
    IFS=',' read -r _ id name raw_desc <<< "${line#*>}"

    # skip duplicates or already-known
    [[ -n "${seen_ids[$id]:-}" ]]       && continue
    [[ -n "${known_monitors[$name]:-}" ]] && continue

    seen_ids[$id]=1

    # only external monitors here (internals already handled on open)
    desc=$(sanitize "$raw_desc")
    apply_profile "$desc"
    known_monitors["$name"]=1
  fi

done
