#!/usr/bin/env bash

SPACE_ICONS=("I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X")

app_icon() {
  case "$1" in
    "com.apple.Safari" | Safari)                 echo "" ;;
    Firefox | "org.mozilla.firefox")             echo "" ;;
    "com.google.Chrome" | "Google Chrome")       echo "" ;;
    "com.brave.Browser" | Brave*)                echo "" ;;
    "com.microsoft.edgemac" | "Microsoft Edge")  echo "" ;;
    "org.mozilla.firefoxdeveloperedition" | \
    "Firefox Developer Edition")                 echo "" ;;

    "com.apple.Terminal" | Terminal)             echo "" ;;
    "com.googlecode.iterm2" | iTerm2)            echo "" ;;
    Ghostty | "com.mitchellh.ghostty")           echo "" ;;
    "net.kovidgoyal.kitty" | kitty)              echo "" ;;
    "io.alacritty" | Alacritty)                  echo "" ;;
    "org.wezfurlong.wezterm" | WezTerm)          echo "" ;;

    Code | "com.microsoft.VSCode" | \
    "com.visualstudio.code")                     echo "" ;;
    "com.microsoft.VSCodeInsiders" | \
    "Visual Studio Code - Insiders")             echo "" ;;
    "com.jetbrains.intellij" | IntelliJ*)        echo "" ;;
    "com.jetbrains.pycharm" | PyCharm*)          echo "" ;;
    "com.jetbrains.webstorm" | WebStorm*)        echo "" ;;
    "com.sublimetext.4" | "Sublime Text")        echo "" ;;
    "com.apple.dt.Xcode" | Xcode)                echo "" ;;

    Discord | "com.hnc.Discord")                 echo "" ;;
    "com.tinyspeck.slackmacgap" | Slack)         echo "" ;;
    "us.zoom.xos" | zoom.us | Zoom)              echo "" ;;
    "com.microsoft.teams" | \
    "com.microsoft.teams2" | Microsoft\ Teams)   echo "" ;;
    "com.apple.FaceTime" | FaceTime)             echo "" ;;
    "com.apple.iChat" | Messages)                echo "" ;;
    "com.apple.mail" | Mail)                     echo "" ;;

    Spotify | "com.spotify.client")              echo "" ;;
    "com.apple.Music" | Music)                   echo "" ;;
    "com.apple.TV" | TV)                         echo "" ;;
    "com.apple.QuickTimePlayerX" | QuickTime*)   echo "" ;;
    "org.videolan.vlc" | VLC)                    echo "" ;;

    "com.apple.finder" | Finder)                 echo "" ;;
    "com.apple.systempreferences" | \
    "com.apple.SystemSettings" | \
    "System Preferences" | "System Settings")    echo "" ;;
    "com.apple.ActivityMonitor" | Activity\ Monitor) echo "" ;;
    "com.apple.Console" | Console)               echo "" ;;
    "com.apple.DiskUtility" | Disk\ Utility)     echo "" ;;
    "com.apple.TimeMachine" | Time\ Machine)     echo "" ;;
    "com.apple.AppStore" | App\ Store)           echo "" ;;
    "com.apple.Preview" | Preview)               echo "" ;;
    "com.apple.Photos" | Photos)                 echo "" ;;
    "com.apple.Calculator" | Calculator)         echo "" ;;
    "com.apple.Calendar" | Calendar)             echo "" ;;
    "com.apple.Notes" | Notes)                   echo "" ;;
    "com.apple.Reminders" | Reminders)           echo "" ;;
    "com.apple.Maps" | Maps)                     echo "" ;;
    "com.apple.Dictionary" | Dictionary)         echo "" ;;
    "com.apple.TextEdit" | TextEdit)             echo "" ;;
    "com.apple.Stickies" | Stickies)             echo "" ;;
    "com.apple.FontBook" | Font\ Book)           echo "" ;;
    "com.apple.Screenshot" | Screenshot)         echo "" ;;
    "com.apple.ImageCapture" | Image\ Capture)   echo "" ;;
    "com.apple.Automator" | Automator)           echo "" ;;
    "com.apple.Shortcuts" | Shortcuts)           echo "" ;;
    "com.apple.Home" | Home)                     echo "" ;;
    "com.apple.Books" | Books)                   echo "" ;;
    "com.apple.News" | News)                     echo "" ;;
    "com.apple.podcasts" | Podcasts)             echo "" ;;

    "com.notion.id" | Notion)                    echo "" ;;
    "com.electron.logseq" | Logseq)              echo "" ;;
    "md.obsidian" | Obsidian)                    echo "" ;;
    "com.todoist.mac.Todoist" | Todoist)         echo "" ;;
    "com.apple.iWork.Pages" | Pages)             echo "" ;;
    "com.apple.iWork.Numbers" | Numbers)         echo "" ;;
    "com.apple.iWork.Keynote" | Keynote)         echo "" ;;
    "com.microsoft.Word" | Microsoft\ Word)      echo "" ;;
    "com.microsoft.Excel" | Microsoft\ Excel)    echo "" ;;
    "com.microsoft.Powerpoint" | Microsoft\ PowerPoint) echo "" ;;

    "com.postmanlabs.mac" | Postman)             echo "" ;;
    "com.docker.docker" | Docker)                echo "" ;;
    "com.github.GitHubClient" | GitHub\ Desktop) echo "" ;;
    "com.jgraph.drawio.desktop" | draw.io)       echo "" ;;

    *) echo "" ;;
  esac
}

# ── Fetch Paneru state ────────────────────────────────────────────────────────
PANERU_DATA="$(paneru query state 2>/dev/null)" || exit 0

workspace_count=$(printf '%s\n' "$PANERU_DATA" | jq '.virtual_workspaces | length')

for (( i=0; i<workspace_count; i++ )); do
  sid=$((i + 1))

  ws=$(printf '%s\n' "$PANERU_DATA" | jq -c ".virtual_workspaces[$i]")

  # Workspace is active if any window in it has focused=true
  is_active=$(printf '%s\n' "$ws" | jq '[.windows[].focused] | any')

  # Build one "iconNumeral" token per window, space-separated
  label=""
  win_count=$(printf '%s\n' "$ws" | jq '.windows | length')

  for (( w=0; w<win_count; w++ )); do
    bundle_id=$(printf '%s\n' "$ws" | jq -r ".windows[$w].bundle_id")
    icon=$(app_icon "$bundle_id")
    numeral="${SPACE_ICONS[$w]}"

    if [ -z "$label" ]; then
      label="${icon}${numeral}"
    else
      label="${label} ${icon}${numeral}"
    fi
  done

  # ── Push to SketchyBar ──────────────────────────────────────────────────────
  if [ -n "$label" ]; then
    sketchybar --set "rift_space.$sid" \
      label="$label"                   \
      label.drawing=on                 \
      label.padding_left=0             \
      label.padding_right=10
  else
    sketchybar --set "rift_space.$sid" label.drawing=off
  fi

  if [ "$is_active" = "true" ]; then
    sketchybar --set "rift_space.$sid" icon.highlight=on
  else
    sketchybar --set "rift_space.$sid" icon.highlight=off
  fi

done
