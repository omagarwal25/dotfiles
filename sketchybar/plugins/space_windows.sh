#!/bin/bash

source "$HOME/.config/sketchybar/aerospace.sh"

update_apps

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" \
    icon="$("$CONFIG_DIR"/plugins/icon_map.sh "$INFO")"
fi
