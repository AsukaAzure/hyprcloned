#!/bin/bash

if pgrep -x "hypridle" >/dev/null; then
    notify-send "Hypridle" "No sleeping!"
    killall hypridle  # stops hypridle
else
    notify-send "Hypridle" "Can sleep!"
    hypridle # starts hypridle
fi
