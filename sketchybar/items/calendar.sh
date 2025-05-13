#!/bin/bash

calendar=(
    icon.font="$FONT:Black:12.0"
    icon.padding_right=0
    label.width=50
    label.align=right
    background.padding_left=5
    update_freq=30
    script="$PLUGIN_DIR/calendar.sh"
    icon=cal
)

sketchybar --add item calendar right \
    --set calendar "${calendar[@]}"
