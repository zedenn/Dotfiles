#!/bin/bash

# Amount to change gaps by (positive or negative)
DELTA="$1"

# Get current gaps_out value
CURRENT=$(hyprctl getoption general:gaps_out | awk 'NR==1 {print $3}')

# Validate input
if [[ -z "$CURRENT" || -z "$DELTA" ]]; then
  exit 1
fi

# Calculate new value
NEW=$((CURRENT + DELTA))

# Apply new value
hyprctl keyword general:gaps_out "$NEW"
