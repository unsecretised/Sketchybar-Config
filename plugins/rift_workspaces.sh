#!/usr/bin/env bash
# Map macOS bundle_id or app name to Nerd Font icon
app_icon() {
  case "$1" in
    Spotify)                     echo "" ;;
    Discord)                     echo "" ;;
    Firefox)                     echo "" ;;
    Ghostty)                     echo "" ;;
    Code)                        echo "" ;;
    "com.microsoft.VSCode" | \
    "com.visualstudio.code")     echo "" ;;
    "com.apple.Safari")          echo "" ;;
    "com.apple.finder" | Finder) echo "" ;;
    "com.apple.Terminal")        echo "" ;;
    *)
      echo ""
      ;;
  esac
}

RIFT_DATA="$(rift-cli query workspaces 2>/dev/null)" || exit 0
workspace_count=$(printf '%s\n' "$RIFT_DATA" | jq 'length')

for (( i=0; i<workspace_count; i++ )); do
  sid=$((i + 1))

  # Check if this workspace is active
  is_active=$(printf '%s\n' "$RIFT_DATA" | jq -r ".[$i].is_active")

  # Get unique bundle_ids for this workspace
  bundle_ids=$(printf '%s\n' "$RIFT_DATA" \
    | jq -r ".[$i].windows[].bundle_id" 2>/dev/null | sort -u)

  icons=""
  if [ -n "$bundle_ids" ]; then
    while IFS= read -r bid; do
      [ -z "$bid" ] && continue
      icons+=$(app_icon "$bid")
    done <<< "$bundle_ids"
  fi

  # Fallback: no windows, no icons
  [ -z "$icons" ] && icons=""

  # Base args
  args=(label="$icons" label.padding_right=0)

  # Add highlight based on active state
  if [ "$is_active" = "true" ]; then
    args+=(icon.highlight=on)
  else
    args+=(icon.highlight=off)
  fi

if [ -n "$icons" ]; then
  sketchybar --set "rift_space.$sid" \
    label="$icons" \
    label.drawing=on \
    label.padding_left=0 \
    label.padding_right=10
else
  sketchybar --set "rift_space.$sid" label.drawing=off
fi
done
