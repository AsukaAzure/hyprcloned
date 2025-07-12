#!/usr/bin/env bash

# variables
TEXT_COLOR="#676c71"
SPOTIFY_ICON="<span color='#ED4236'>󰓇  </span>"
FIREFOX_ICON="<span color='#f38ba8'>󰗃  </span>"
MUSIKCUBE_ICON="<span color='#FFE4B5'>󰽷 </span>"
YOUTUBE_ICON="<span color='#ED4236'> </span>"
PAUSE_ICON="<span color='#b4befe'> 󰏤   </span>"
None="<span color='#ED4236'> </span>"
# this uses hair spaces and thin spaces
# \u200A󰏤 \u2009\u2009\u200A

# list active players
players=$(playerctl --list-all)

format_output() {
  local player="$1"
  local status
  local artist
  local title
  local icon
  local text

  # get playback status, artist, and title
  status=$(playerctl --player="$player" status 2>/dev/null)
  artist=$(playerctl --player="$player" metadata artist 2>/dev/null)
  title=$(playerctl --player="$player" metadata title 2>/dev/null)

  # escape special characters
  artist=$(echo "$artist" | sed 's/&/\&amp;/g')
  title=$(echo "$title" | sed 's/&/\&amp;/g')

  # icon based on player and status
  if [[ "$status" == "Playing" ]]; then
    if [[ "$player" == *"spotify"* ]]; then
      icon="$SPOTIFY_ICON"
    elif [[ "$player" == *"musikcube"* ]]; then
      icon="$MUSIKCUBE_ICON"
    elif [[ "$player" == *"chromium"* ]]; then
      icon="$YOUTUBE_ICON"
    elif [[ "$player" == *"firefox"* ]]; then
      icon="$FIREFOX_ICON"
    else
      icon="$None "
    fi
  elif [[ "$status" == "Paused" ]]; then
    icon="$PAUSE_ICON"
  else
    icon=""
  fi

  # track info
  if [[ -n "$artist" && -n "$title" ]]; then
    text="${icon}<span color='${TEXT_COLOR}'><b>${title}</b> — ${artist}</span>"
  elif [[ -n "$title" ]]; then
    text="${icon}<span color='${TEXT_COLOR}'>${title}</span>"
  else
    text=""
  fi

  [[ -n "$text" ]] && echo "$text"
}


# loop through players
for player in $players; do
  if [[ $(playerctl --player="$player" status 2>/dev/null) == "Playing" ]]; then
    format_output "$player"
    exit 0
  fi
done

# if no players are playing, show the first player
if [[ -n "$players" ]]; then
  format_output "$(echo "$players" | head -n 1)"
fi
