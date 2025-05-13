#!/bin/bash

for sid in $(aerospace list-workspaces --all); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    sketchybar --set space."$sid" drawing=on
    while read -r app; do
      icon_strip+=" $("$CONFIG_DIR"/plugins/icon_map.sh "$app")"
    done <<<"${apps}"
  else
    icon_strip=""
  fi
  sketchybar --set space."$sid" label="$icon_strip"
done

if [ "$SENDER" = "front_app_switched" ]; then

  sketchybar --set "$NAME" \
    icon="$("$CONFIG_DIR"/plugins/icon_map.sh "$INFO")"
fi

