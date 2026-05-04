#!/bin/bash

# How many icons did we create?
SPACE_ICONS=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")
max_spaces=${#SPACE_ICONS[@]}

# Get workspace info from rift-cli
RIFT_DATA="$(rift-cli query workspaces 2>/dev/null || echo '[]')"

active_index=$(printf '%s\n' "$RIFT_DATA" | jq '
  map(.is_active) | map(. == true) | index(true)
')

# If no active workspace found, just clear borders
if [ "$active_index" = "null" ] || [ -z "$active_index" ]; then
  for (( i=0; i<max_spaces; i++ )); do
    sid=$((i + 1))
    sketchybar --set "rift_space.$sid" background.border_width=0
  done
  exit 0
fi

# active_index is 0‑based, our sid is 1‑based
active_sid=$((active_index + 1))

for (( i=0; i<max_spaces; i++ )); do
  sid=$((i + 1))
  if [ "$sid" -eq "$active_sid" ]; then
    # Show border on active
    sketchybar --set "rift_space.$sid" label.drawing=on
  else
    # Hide border on others
    sketchybar --set "rift_space.$sid" label.drawing=on
  fi
done
