#!/usr/bin/env bash
set -euo pipefail

profiles="$HOME/.config/hypr/monitors/profiles"
mkdir -p "$profiles"

hyprctl -j monitors \
  | jq -r '.[].description' \
  | while read -r desc; do
      # skip blank or null
      [[ -z "$desc" ]] && continue

      # sanitize: lowercase, non-alnum → underscore, trim edges
      key=$(echo "$desc" \
        | tr '[:upper:]' '[:lower:]' \
        | sed -E 's/[^a-z0-9]+/_/g; s/^_|_$//g')

      file="$profiles/$key.conf"

      # create file if missing
      if [[ ! -f "$file" ]]; then
        touch "$file"
        echo "Created blank profile: $file"
      fi
    done
