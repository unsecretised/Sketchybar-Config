#!/usr/bin/env bash
# Watches paneru state and triggers sketchybar when windows change.
# Launch this once from sketchybarrc or your shell rc.

while true; do
  current_state="$(paneru query state 2>/dev/null \
    | jq -c '[.virtual_workspaces[].windows | length]')"

  if [ "$current_state" != "$prev_state" ]; then
    sketchybar --trigger paneru_update
    prev_state="$current_state"
  fi

  sleep 0.5   # check every 500ms — fast but not spammy
done
