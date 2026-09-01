#!/usr/bin/env bash

FG_DIM="0x727169"

app_icon() {
  case "$1" in
    "com.umangsurana.idiot")                     echo "" ;;
    "com.apple.Safari" | Safari)                 echo "" ;;
    Firefox | "org.mozilla.firefox")             echo "" ;;
    Zen | "app.zen-browser.zen")                 echo "󰺕" ;;
    "com.google.Chrome" | "Google Chrome")       echo "" ;;
    "com.brave.Browser" | Brave*)                echo "" ;;
    "com.microsoft.edgemac" | "Microsoft Edge")  echo "" ;;
    "org.mozilla.firefoxdeveloperedition" | \
    "Firefox Developer Edition")                 echo "" ;;
    "com.apple.Terminal" | Terminal)             echo "" ;;
    "com.googlecode.iterm2" | iTerm2)            echo "" ;;
    "com.apple.reminders")                       echo "" ;;
    Ghostty | "com.mitchellh.ghostty")           echo "" ;;
    "net.kovidgoyal.kitty" | kitty)              echo "" ;;
    "io.alacritty" | Alacritty)                  echo "" ;;
    "org.wezfurlong.wezterm" | WezTerm)          echo "" ;;
    Code | "com.microsoft.VSCode")               echo "" ;;
    "net.imput.helium")                          echo ""  ;; 
    "com.jetbrains.intellij" | IntelliJ*)        echo "" ;;
    "com.jetbrains.pycharm" | PyCharm*)          echo "" ;;
    "com.sublimetext.4" | "Sublime Text")        echo "" ;;
    "com.apple.dt.Xcode" | Xcode)                echo "" ;;
    Discord | "com.hnc.Discord")                 echo "" ;;
    Vesktop | "dev.vencord.vesktop")             echo "" ;;
    "com.tinyspeck.slackmacgap" | Slack)         echo "" ;;
    "us.zoom.xos" | zoom.us | Zoom)              echo "" ;;
    "com.apple.FaceTime" | FaceTime)             echo "" ;;
    "com.apple.iChat" | Messages)                echo "" ;;
    "com.apple.mail" | Mail)                     echo "" ;;
    Spotify | "com.spotify.client")              echo "" ;;
    "com.apple.Music" | Music)                   echo "" ;;
    "com.apple.finder" | Finder)                 echo "" ;;
    "com.apple.systempreferences" | \
    "com.apple.SystemSettings" | \
    "System Preferences" | "System Settings")    echo "" ;;
    "com.apple.ActivityMonitor" | Activity\ Monitor) echo "" ;;
    "com.apple.Preview" | Preview)               echo "" ;;
    "com.apple.Photos" | Photos)                 echo "" ;;
    "com.apple.Calculator" | Calculator)         echo "" ;;
    "com.apple.iCal" | Calendar)                 echo "" ;;
    "com.apple.Notes" | Notes)                   echo "" ;;
    "com.apple.Reminders" | Reminders)           echo "" ;;
    "com.apple.Maps" | Maps)                     echo "" ;;
    "com.apple.TextEdit" | TextEdit)             echo "" ;;
    "com.apple.Stickies" | Stickies)             echo "" ;;
    "com.apple.FontBook" | Font\ Book)           echo "" ;;
    "com.apple.Shortcuts" | Shortcuts)           echo "" ;;
    "com.apple.Home" | Home)                     echo "" ;;
    "com.apple.Books" | Books)                   echo "" ;;
    "md.obsidian" | Obsidian)                    echo "" ;;
    "com.todoist.mac.Todoist" | Todoist)         echo "" ;;
    "com.microsoft.Word" | Microsoft\ Word)      echo "" ;;
    "com.microsoft.Excel" | Microsoft\ Excel)    echo "" ;;
    "com.microsoft.Powerpoint" | Microsoft\ PowerPoint) echo "" ;;
    "com.docker.docker" | Docker)                echo "" ;;
    "com.github.GitHubClient" | GitHub\ Desktop) echo "" ;;
    *)
      echo ""
      ;;
  esac
}

DATA="$(bobrwm query workspaces --json 2>/dev/null)" || exit 0
count=$(printf '%s\n' "$DATA" | jq 'length')

for (( i=0; i<count; i++ )); do
  sid=$((i + 1))

  visible=$(printf '%s\n' "$DATA" | jq -r ".[$i].visible")

  bundle_ids=$(printf '%s\n' "$DATA" \
    | jq -r ".[$i].windows[].bundle_id" 2>/dev/null | sort -u)

  icons=""
  if [ -n "$bundle_ids" ]; then
    while IFS= read -r bid; do
      [ -z "$bid" ] && continue
      [ -n "$icons" ] && icons+=" "
      icons+="$(app_icon "$bid")"
    done <<< "$bundle_ids"
  fi

  if [ "$visible" = "true" ]; then
    sketchybar --set "workspace.$sid" \
      icon.highlight=on \
      label="$icons" \
      label.drawing=on \
      icon.padding_right=0 \
      background.color=0x30${FG_DIM:2} \
      background.border_width=1 \
      background.border_color=0x60${FG_DIM:2}
  else
    sketchybar --set "workspace.$sid" \
      icon.highlight=off \
      label="$icons" \
      label.drawing=on \
      icon.padding_right=2 \
      background.color=0x00000000 \
      background.border_width=0
  fi
done
