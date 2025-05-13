#!/bin/bash

sketchybar --add item space_separator left \
    --set space_separator icon="👀" \
    icon.font="sketchybar-app-font:Regular:16.0" \
    label.drawing=off \
    background.drawing=off \
    icon.padding_right=0 \
    display="active" \
    script="$PLUGIN_DIR/space_windows.sh" \
    --subscribe space_separator aerospace_workspace_change front_app_switched \
    --subscribe space_separator change-workspace-monitor

sketchybar --add item front_app left \
    --set front_app icon.drawing=off \
    script="$PLUGIN_DIR/front_app.sh" \
    display="active" \
    label.padding_left=0 \
    label.font="$FONT:Bold:14.0" \
    --subscribe front_app front_app_switched
