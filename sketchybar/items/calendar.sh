#!/bin/bash

calendar=(
    icon.font="$FONT:Black:12.0"
    label.font="$FONT:Semibold:13.0"
    icon.padding_right=5
    label.width=45
    label.align=right
    update_freq=30
    script="$PLUGIN_DIR/calendar.sh"
    icon=cal
)

sketchybar --add item calendar right \
    --set calendar "${calendar[@]}"
