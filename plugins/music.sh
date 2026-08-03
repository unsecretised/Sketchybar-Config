#!/bin/sh
update() {
  RUNNING=$(osascript -e 'application "Music" is running')
  if [ "$RUNNING" = "false" ]; then
    sketchybar -m --set music drawing=off popup.drawing=off
    exit 0
  fi
  STATE=$(osascript -e 'tell application "Music" to player state')
  TRACK=$(osascript -e 'tell application "Music" to name of current track')
  ARTIST=$(osascript -e 'tell application "Music" to artist of current track')
  SHUFFLE=$(osascript -e 'tell application "Music" to shuffle enabled')
  REPEAT=$(osascript -e 'tell application "Music" to song repeat')
  sketchybar -m --set music drawing=on
  if [ "$STATE" = "playing" ]; then
    sketchybar -m --set music.track label="${TRACK}  ${ARTIST}"
    sketchybar -m --set music.play icon=󰐊
  else
    sketchybar -m --set music.track label="${TRACK}  ${ARTIST} (paused)"
    sketchybar -m --set music.play icon=󰐊
  fi
  sketchybar -m --set music.shuffle icon.highlight="$SHUFFLE"
  if [ "$REPEAT" = "off" ]; then
    sketchybar -m --set music.repeat icon.highlight=off
  else
    sketchybar -m --set music.repeat icon.highlight=on
  fi
}
next()     { osascript -e 'tell application "Music" to play next track'; }
back()     { osascript -e 'tell application "Music" to play previous track'; }
play()     { osascript -e 'tell application "Music" to playpause'; }
repeat() {
  REPEAT=$(osascript -e 'tell application "Music" to get song repeat')
  if [ "$REPEAT" = "off" ]; then
    sketchybar -m --set music.repeat icon.highlight=on
    osascript -e 'tell application "Music" to set song repeat to all'
  else
    sketchybar -m --set music.repeat icon.highlight=off
    osascript -e 'tell application "Music" to set song repeat to off'
  fi
}
shuffle() {
  SHUFFLE=$(osascript -e 'tell application "Music" to get shuffle enabled')
  if [ "$SHUFFLE" = "false" ]; then
    sketchybar -m --set music.shuffle icon.highlight=on
    osascript -e 'tell application "Music" to set shuffle enabled to true'
  else
    sketchybar -m --set music.shuffle icon.highlight=off
    osascript -e 'tell application "Music" to set shuffle enabled to false'
  fi
}
mouse_clicked() {
  case "$NAME" in
    "music.next")     next ;;
    "music.back")     back ;;
    "music.play")     play ;;
    "music.shuffle")  shuffle ;;
    "music.repeat")   repeat ;;
  esac
}
case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  *)               update ;;
esac
