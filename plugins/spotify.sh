#!/bin/sh

update() {
  RUNNING=$(osascript -e 'application "Spotify" is running')

  if [ "$RUNNING" = "false" ]; then
    sketchybar -m --set spotify drawing=off popup.drawing=off
    exit 0
  fi

  STATE=$(osascript -e 'tell application "Spotify" to player state')
  TRACK=$(osascript -e 'tell application "Spotify" to name of current track')
  ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track')

  SHUFFLE=$(osascript -e 'tell application "Spotify" to shuffling')
  REPEAT=$(osascript -e 'tell application "Spotify" to repeating')

  sketchybar -m --set spotify drawing=on

  if [ "$STATE" = "playing" ]; then
    sketchybar -m --set spotify.track label="${TRACK}  ${ARTIST}"
    sketchybar -m --set spotify.play icon=󰐊
  else
    sketchybar -m --set spotify.track label="${TRACK}  ${ARTIST} (paused)"
    sketchybar -m --set spotify.play icon=󰐊
  fi

  sketchybar -m --set spotify.shuffle icon.highlight="$SHUFFLE"
  sketchybar -m --set spotify.repeat icon.highlight="$REPEAT"
}

next()     { osascript -e 'tell application "Spotify" to play next track'; }
back()     { osascript -e 'tell application "Spotify" to play previous track'; }
play()     { osascript -e 'tell application "Spotify" to playpause'; }

repeat() {
  REPEAT=$(osascript -e 'tell application "Spotify" to get repeating')
  if [ "$REPEAT" = "false" ]; then
    sketchybar -m --set spotify.repeat icon.highlight=on
    osascript -e 'tell application "Spotify" to set repeating to true'
  else
    sketchybar -m --set spotify.repeat icon.highlight=off
    osascript -e 'tell application "Spotify" to set repeating to false'
  fi
}

shuffle() {
  SHUFFLE=$(osascript -e 'tell application "Spotify" to get shuffling')
  if [ "$SHUFFLE" = "false" ]; then
    sketchybar -m --set spotify.shuffle icon.highlight=on
    osascript -e 'tell application "Spotify" to set shuffling to true'
  else
    sketchybar -m --set spotify.shuffle icon.highlight=off
    osascript -e 'tell application "Spotify" to set shuffling to false'
  fi
}

mouse_clicked() {
  case "$NAME" in
    "spotify.next")     next ;;
    "spotify.back")     back ;;
    "spotify.play")     play ;;
    "spotify.shuffle")  shuffle ;;
    "spotify.repeat")   repeat ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  *)               update ;;
esac
