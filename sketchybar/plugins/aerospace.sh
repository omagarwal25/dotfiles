#!/bin/bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$SENDER" == "mouse.entered" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")

    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        exit 0
    fi

    sketchybar --set "$NAME" \
        background.drawing=on \
        exit 0
elif [ "$SENDER" == "mouse.exited" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")

    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        exit 0
    fi

    sketchybar --set "$NAME" \
        background.drawing=off \
        exit 0
elif [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate sin 10 --set "$NAME" background.drawing=on y_offset=5 y_offset=0
else
    sketchybar --set "$NAME" background.drawing=off
fi
