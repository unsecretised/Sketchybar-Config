#!/usr/bin/env bash

BG_BASE="0x1f1f28"        
BG_SURFACE="0x2a2a37"     
BG_OVERLAY="0x363646"    

WAVE_BLUE="0x7e9cd8"    
SPRING_VIOLET="0x957fb8"
AUTUMN_RED="0xc34043"   
WAVE_AQUA="0x7fb4ca"     
SPRING_GREEN="0x98bb6c"  
AUTUMN_YELLOW="0xdca561" 
SAKURA_PINK="0xd27e99"   
OLD_WHITE="0xdcd7ba"     

FG_PRIMARY="0xdcd7ba"    
FG_SECONDARY="0xc8c093"  
FG_DIM="0x727169"        

WALL_BASE="0x2d343f"      
WALL_MUTED="0x3d4a5c"     
WALL_ACCENT="0x4a5f7a"    

app_icon() {
  case "$1" in
    # Browsers
    "com.apple.Safari" | Safari)                 echo "" ;;
    Firefox | "org.mozilla.firefox")             echo "" ;;
    "com.google.Chrome" | "Google Chrome")       echo "" ;;
    "com.brave.Browser" | Brave*)                echo "" ;;
    "com.microsoft.edgemac" | "Microsoft Edge")  echo "" ;;
    "org.mozilla.firefoxdeveloperedition" | \
    "Firefox Developer Edition")                 echo "" ;;

    # Terminals
    "com.apple.Terminal" | Terminal)             echo "" ;;
    "com.googlecode.iterm2" | iTerm2)            echo "" ;;
    Ghostty | "com.mitchellh.ghostty")           echo "" ;;
    "net.kovidgoyal.kitty" | kitty)              echo "" ;;
    "io.alacritty" | Alacritty)                  echo "" ;;
    "org.wezfurlong.wezterm" | WezTerm)          echo "" ;;

    # Editors / IDE
    Code | "com.microsoft.VSCode" | \
    "com.visualstudio.code")                     echo "" ;;
    "com.microsoft.VSCodeInsiders" | \
    "Visual Studio Code - Insiders")             echo "" ;;
    "com.jetbrains.intellij" | IntelliJ*)        echo "" ;;
    "com.jetbrains.pycharm" | PyCharm*)          echo "" ;;
    "com.jetbrains.webstorm" | WebStorm*)        echo "" ;;
    "com.sublimetext.4" | "Sublime Text")        echo "" ;;
    "com.apple.dt.Xcode" | Xcode)                echo "" ;;

    # Chat / meetings
    Discord | "com.hnc.Discord")                 echo "" ;;
    "com.tinyspeck.slackmacgap" | Slack)         echo "" ;;
    "us.zoom.xos" | zoom.us | Zoom)              echo "" ;;
    "com.microsoft.teams" | \
    "com.microsoft.teams2" | Microsoft\ Teams)   echo "" ;;
    "com.apple.FaceTime" | FaceTime)             echo "" ;;
    "com.apple.iChat" | Messages)                echo "" ;;
    "com.apple.mail" | Mail)                     echo "" ;;

    # Music / media
    Spotify | "com.spotify.client")              echo "" ;;
    "com.apple.Music" | Music)                   echo "" ;;
    "com.apple.TV" | TV)                         echo "" ;;
    "com.apple.QuickTimePlayerX" | QuickTime*)   echo "" ;;
    "org.videolan.vlc" | VLC)                    echo "" ;;

    # Apple / system
    "com.apple.finder" | Finder)                 echo "" ;;
    "com.apple.systempreferences" | \
    "com.apple.SystemSettings" | \
    "System Preferences" | "System Settings")    echo "" ;;
    "com.apple.ActivityMonitor" | Activity\ Monitor) echo "" ;;
    "com.apple.Console" | Console)               echo "" ;;
    "com.apple.DiskUtility" | Disk\ Utility)     echo "" ;;
    "com.apple.TimeMachine" | Time\ Machine)     echo "" ;;
    "com.apple.AppStore" | App\ Store)           echo "" ;;
    "com.apple.Preview" | Preview)               echo "" ;;
    "com.apple.Photos" | Photos)                 echo "" ;;
    "com.apple.Calculator" | Calculator)         echo "" ;;
    "com.apple.Calendar" | Calendar)             echo "" ;;
    "com.apple.Notes" | Notes)                   echo "" ;;
    "com.apple.Reminders" | Reminders)           echo "" ;;
    "com.apple.Maps" | Maps)                     echo "" ;;
    "com.apple.Dictionary" | Dictionary)         echo "" ;;
    "com.apple.TextEdit" | TextEdit)             echo "" ;;
    "com.apple.Stickies" | Stickies)             echo "" ;;
    "com.apple.FontBook" | Font\ Book)           echo "" ;;
    "com.apple.Screenshot" | Screenshot)         echo "" ;;
    "com.apple.ImageCapture" | Image\ Capture)   echo "" ;;
    "com.apple.Automator" | Automator)           echo "" ;;
    "com.apple.Shortcuts" | Shortcuts)           echo "" ;;
    "com.apple.Home" | Home)                     echo "" ;;
    "com.apple.Books" | Books)                   echo "" ;;
    "com.apple.News" | News)                     echo "" ;;
    "com.apple.Poddcasts" | Podcasts | \
    "com.apple.podcasts")                        echo "" ;;

    # Cloud / notes / productivity
    "com.notion.id" | Notion)                    echo "" ;;
    "com.electron.logseq" | Logseq)              echo "" ;;
    "md.obsidian" | Obsidian)                    echo "" ;;
    "com.todoist.mac.Todoist" | Todoist)         echo "" ;;
    "com.apple.iWork.Pages" | Pages)             echo "" ;;
    "com.apple.iWork.Numbers" | Numbers)         echo "" ;;
    "com.apple.iWork.Keynote" | Keynote)         echo "" ;;
    "com.microsoft.Word" | Microsoft\ Word)      echo "" ;;
    "com.microsoft.Excel" | Microsoft\ Excel)    echo "" ;;
    "com.microsoft.Powerpoint" | Microsoft\ PowerPoint) echo "" ;;

    # Dev tools
    "com.apple.SafariTechnologyPreview" | \
    "Safari Technology Preview")                 echo "" ;;
    "com.postmanlabs.mac" | Postman)             echo "" ;;
    "com.docker.docker" | Docker)                echo "" ;;
    "com.github.GitHubClient" | GitHub\ Desktop) echo "" ;;
    "com.tinyspeck.slackmacgap" | Slack)         echo "" ;;
    "com.jgraph.drawio.desktop" | draw.io)       echo "" ;;

    *)
      echo ""
      ;;
  esac
}

PANERU_DATA="$(paneru query state 2>/dev/null || echo '{}')"

window_count=$(printf '%s\n' "$PANERU_DATA" \
  | jq '.virtual_workspaces[0].windows | length' 2>/dev/null || echo 0)

# Build icons for each window
icons=""
for (( i=0; i<window_count; i++ )); do
  app_id=$(printf '%s\n' "$PANERU_DATA" \
    | jq -r ".virtual_workspaces[0].windows[$i].bundle_id // \
              .virtual_workspaces[0].windows[$i].app_name // \
              \"\"")

  icon="$(app_icon "$app_id")"
  icons+="$icon  "
done

icons="${icons%" "}"  # trim trailing space

if [[ -z "$icons" ]]; then
  icons=""  # fallback when no windows
fi

sketchybar --set paneru_windows icon="$icons"
