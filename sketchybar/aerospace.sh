#!/bin/bash

update_apps() {
  for sid in $(aerospace list-workspaces --all); do
    apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    # Get the monitor ID for the workspace
    monitor_id=$(get_workspace_monitor_id "$sid")

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      sketchybar --set space."$sid" drawing=on
      while read -r app; do
        icon_strip+=" $("$CONFIG_DIR"/plugins/icon_map.sh "$app")"
      done <<<"${apps}"
    else
      sketchybar --set space."$sid" drawing=off
      icon_strip=""
    fi
    sketchybar --set space."$sid" label="$icon_strip" display="$monitor_id"
  done
}

get_workspace_monitor_id() {
  local workspace_id="$1"
  # aerospace command that returns all windows in the workspace, formatted as only the system monitor ID
  # each workspace is 1 character long, so truncate the output to only the first character
  local aerospace_result
  aerospace_result=$(aerospace list-windows --workspace "$workspace_id" --format "%{monitor-appkit-nsscreen-screens-id}")

  local monitor_id=${aerospace_result:0:1}
  echo "$monitor_id"
}
