#!/bin/bash

source "$HOME/.config/sketchybar/aerospace.sh"

sketchybar --add event aerospace_workspace_change
sketchybar --add event change-workspace-monitor

for sid in $(aerospace list-workspaces --all); do

    # Get the monitor ID for the workspace
    monitor_id=$(get_workspace_monitor_id "$sid")

    space_item=(
        background.color="$BACKGROUND_3"
        display="$monitor_id"
        label.font="sketchybar-app-font:Regular:16.0"
        label.padding_right=20
        label.y_offset=-1
        label.padding_left=0
        background.corner_radius=5
        background.height=25
        background.drawing=off
        icon.padding_left=10
        icon="$sid"
        click_script="aerospace workspace $sid"
        drawing=off
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    )

    sketchybar --add item space."$sid" left \
        --subscribe space."$sid" aerospace_workspace_change mouse.entered mouse.exited \
        --set space."$sid" "${space_item[@]}"
done

update_apps
