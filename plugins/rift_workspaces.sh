#!/usr/bin/env bash

# Map macOS bundle_id or app name to Nerd Font icon
app_icon() {
  case "$1" in
    Spotify)                     echo "" ;;        # nf-fa-spotify
    Discord)                     echo "" ;;        # nf-fa-discord
    Firefox)                     echo "" ;;        # nf-fa-firefox
    Ghostty)                     echo "" ;;        # Terminal icon
    Code)                        echo "" ;;        # VS Code (generic name)
    "com.microsoft.VSCode" | \
    "com.visualstudio.code")     echo "" ;;        # VS Code (bundle IDs)
    "com.apple.Safari")          echo "" ;;        # nf-fa-globe
    "com.apple.finder" | Finder) echo "" ;;        # nf-oct-file-directory
    "com.apple.Terminal")        echo "" ;;        # nf-fa-terminal
    *)
      # Default generic window icon
      echo ""
      ;;
  esac
}

RIFT_DATA="$(rift-cli query workspaces 2>/dev/null)" || exit 0

workspace_count=$(printf '%s\n' "$RIFT_DATA" | jq 'length')

for (( i=0; i<workspace_count; i++ )); do
  sid=$((i + 1))

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

  # If there are no windows, clear label
  if [ -z "$icons" ]; then
    icons=""
  fi

  # Update label for the corresponding SketchyBar item
  sketchybar --set "rift_space.$sid" label="$icons" label.padding_right=10
  if [ -z "$icons" ]; then
    sketchybar --set "rift_space.$sid" label="$icons" label.padding_left=0
  fi
done
