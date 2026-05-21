#!/usr/bin/env bash

# ── Icon map: bundle_id or app name → Nerd Font glyph ────────────────────────
app_icon() {
  case "$1" in
    # Browsers
    "com.apple.Safari"|Safari)                          echo "" ;;
    Firefox|"org.mozilla.firefox")                      echo "" ;;
    "com.google.Chrome"|"Google Chrome")                echo "" ;;
    "com.brave.Browser"|Brave*)                         echo "" ;;
    "com.microsoft.edgemac"|"Microsoft Edge")           echo "" ;;
    "org.mozilla.firefoxdeveloperedition"|"Firefox Developer Edition") echo "" ;;

    # Terminals
    "com.apple.Terminal"|Terminal)                      echo "" ;;
    "com.googlecode.iterm2"|iTerm2)                     echo "" ;;
    Ghostty|"com.mitchellh.ghostty")                    echo "" ;;
    "net.kovidgoyal.kitty"|kitty)                       echo "" ;;
    "io.alacritty"|Alacritty)                           echo "" ;;
    "org.wezfurlong.wezterm"|WezTerm)                   echo "" ;;

    # Editors / IDE
    Code|"com.microsoft.VSCode"|"com.visualstudio.code") echo "" ;;
    "com.microsoft.VSCodeInsiders"|"Visual Studio Code - Insiders") echo "" ;;
    "com.jetbrains.intellij"|IntelliJ*)                 echo "" ;;
    "com.jetbrains.pycharm"|PyCharm*)                   echo "" ;;
    "com.jetbrains.webstorm"|WebStorm*)                 echo "" ;;
    "com.sublimetext.4"|"Sublime Text")                 echo "" ;;
    "com.apple.dt.Xcode"|Xcode)                         echo "" ;;

    # Chat / meetings
    Discord|"com.hnc.Discord")                          echo "" ;;
    "com.tinyspeck.slackmacgap"|Slack)                  echo "" ;;
    "us.zoom.xos"|zoom.us|Zoom)                         echo "" ;;
    "com.microsoft.teams"|"com.microsoft.teams2"|Microsoft\ Teams) echo "" ;;
    "com.apple.FaceTime"|FaceTime)                      echo "" ;;
    "com.apple.iChat"|Messages)                         echo "" ;;
    "com.apple.mail"|Mail)                              echo "" ;;

    # Music / media
    Spotify|"com.spotify.client")                       echo "" ;;
    "com.apple.Music"|Music)                            echo "" ;;
    "com.apple.TV"|TV)                                  echo "" ;;
    "com.apple.QuickTimePlayerX"|QuickTime*)            echo "" ;;
    "org.videolan.vlc"|VLC)                             echo "" ;;

    # Apple / system
    "com.apple.finder"|Finder)                          echo "" ;;
    "com.apple.systempreferences"|"com.apple.SystemSettings"|\
    "System Preferences"|"System Settings")             echo "" ;;
    "com.apple.ActivityMonitor"|Activity\ Monitor)      echo "" ;;
    "com.apple.Console"|Console)                        echo "" ;;
    "com.apple.DiskUtility"|Disk\ Utility)              echo "" ;;
    "com.apple.TimeMachine"|Time\ Machine)              echo "" ;;
    "com.apple.AppStore"|App\ Store)                    echo "" ;;
    "com.apple.Preview"|Preview)                        echo "" ;;
    "com.apple.Photos"|Photos)                          echo "" ;;
    "com.apple.Calculator"|Calculator)                  echo "" ;;
    "com.apple.Calendar"|Calendar)                      echo "" ;;
    "com.apple.Notes"|Notes)                            echo "" ;;
    "com.apple.Reminders"|Reminders)                    echo "" ;;
    "com.apple.Maps"|Maps)                              echo "" ;;
    "com.apple.Dictionary"|Dictionary)                  echo "" ;;
    "com.apple.TextEdit"|TextEdit)                      echo "" ;;
    "com.apple.Stickies"|Stickies)                      echo "" ;;
    "com.apple.FontBook"|Font\ Book)                    echo "" ;;
    "com.apple.Screenshot"|Screenshot)                  echo "" ;;
    "com.apple.Automator"|Automator)                    echo "" ;;
    "com.apple.Shortcuts"|Shortcuts)                    echo "" ;;
    "com.apple.Home"|Home)                              echo "" ;;
    "com.apple.Books"|Books)                            echo "" ;;
    "com.apple.News"|News)                              echo "" ;;
    "com.apple.podcasts"|Podcasts)                      echo "" ;;

    # Productivity / notes
    "com.notion.id"|Notion)                             echo "" ;;
    "com.electron.logseq"|Logseq)                       echo "" ;;
    "md.obsidian"|Obsidian)                             echo "" ;;
    "com.todoist.mac.Todoist"|Todoist)                  echo "" ;;
    "com.apple.iWork.Pages"|Pages)                      echo "" ;;
    "com.apple.iWork.Numbers"|Numbers)                  echo "" ;;
    "com.apple.iWork.Keynote"|Keynote)                  echo "" ;;
    "com.microsoft.Word"|Microsoft\ Word)               echo "" ;;
    "com.microsoft.Excel"|Microsoft\ Excel)             echo "" ;;
    "com.microsoft.Powerpoint"|Microsoft\ PowerPoint)   echo "" ;;

    # Dev tools
    "com.postmanlabs.mac"|Postman)                      echo "" ;;
    "com.docker.docker"|Docker)                         echo "" ;;
    "com.github.GitHubClient"|GitHub\ Desktop)          echo "" ;;
    "com.jgraph.drawio.desktop"|draw.io)                echo "" ;;

    *) echo "" ;;
  esac
}

# ── Query rift-cli once ───────────────────────────────────────────────────────
RIFT_DATA="$(rift-cli query workspaces 2>/dev/null)" || exit 0
[ -z "$RIFT_DATA" ] || [ "$RIFT_DATA" = "null" ] && exit 0

workspace_count=$(printf '%s\n' "$RIFT_DATA" | jq 'length')
MAX_SPACES=10

# ── Update each space slot ────────────────────────────────────────────────────
for (( i=0; i<MAX_SPACES; i++ )); do
  sid=$((i + 1))
  item="rift_space.$sid"

  # Hide slots beyond what rift reports
  if (( i >= workspace_count )); then
    sketchybar --set "$item" drawing=off
    continue
  fi

  # Active state
  is_active=$(printf '%s\n' "$RIFT_DATA" | jq -r ".[$i].is_active")

  # Collect unique bundle_ids → icons (space-separated glyphs)
  icons=""
  while IFS= read -r bid; do
    [ -z "$bid" ] && continue
    icons+="$(app_icon "$bid") "
  done < <(printf '%s\n' "$RIFT_DATA" | jq -r ".[$i].windows[].bundle_id" 2>/dev/null | sort -u)

  # Trim trailing space
  icons="${icons% }"

  # Build the update args
  if [ "$is_active" = "true" ]; then
    highlight_args=(
      icon.highlight=on
      icon.color=0xff${WAVE_BLUE:-7e9cd8}   # brighten active icon
      background.color=0x20${WAVE_BLUE:-7e9cd8}
      background.border_width=1
      background.border_color=0x60${WAVE_BLUE:-7e9cd8}
    )
  else
    highlight_args=(
      icon.highlight=off
      icon.color=0x60${WAVE_BLUE:-7e9cd8}   # dim inactive
      background.color=0x00000000
      background.border_width=0
    )
  fi

  if [ -n "$icons" ]; then
    sketchybar --set "$item" \
      drawing=on \
      label="$icons" \
      label.drawing=on \
      label.padding_left=2 \
      label.padding_right=6 \
      "${highlight_args[@]}"
  else
    # Workspace exists but is empty — show just the number icon, no label
    sketchybar --set "$item" \
      drawing=on \
      label.drawing=off \
      "${highlight_args[@]}"
  fi
done
