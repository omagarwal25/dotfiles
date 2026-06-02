#!/bin/bash

SKETCHYBAR=/opt/homebrew/bin/sketchybar
MAX=45
ICON_PLAYING=􀑪
ICON_PAUSED=􀊆

prev=""
while true; do
    title=$(nowplaying-cli get title 2>/dev/null)
    artist=$(nowplaying-cli get artist 2>/dev/null)
    rate=$(nowplaying-cli get playbackRate 2>/dev/null)

    if [ "$title" = "null" ] || [ -z "$title" ]; then
        if [ "$prev" != "__off" ]; then
            $SKETCHYBAR --set media drawing=off
            prev="__off"
        fi
    else
        if [ "$artist" = "null" ] || [ -z "$artist" ]; then
            label="$title"
        else
            label="$artist - $title"
        fi

        if [ ${#label} -gt $MAX ]; then
            label="${label:0:$((MAX - 1))}…"
        fi

        if [ "$rate" = "0" ]; then
            icon=$ICON_PAUSED
        else
            icon=$ICON_PLAYING
        fi

        state="$icon|$label"
        if [ "$state" != "$prev" ]; then
            $SKETCHYBAR --set media icon="$icon" label="$label" drawing=on
            prev="$state"
        fi
    fi

    sleep 1
done
