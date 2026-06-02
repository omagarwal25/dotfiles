#!/bin/bash

media=(
  icon=􀑪
  icon.font="$FONT:Bold:14.0"
  drawing=off
  label.font="$FONT:Bold:14.0"
)

sketchybar --add item media right \
  --set media "${media[@]}"
