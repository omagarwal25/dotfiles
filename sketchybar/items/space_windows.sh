#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left                          \
               --subscribe space.$sid aerospace_workspace_change   \
               --set space.$sid                                    \
                     background.color=0x44ffffff                   \
                     label.font="sketchybar-app-font:Regular:16.0" \
                     label.padding_right=20                        \
                     label.y_offset=-1                             \
                     label.padding_left=0                          \
                     background.corner_radius=5                    \
                     background.height=25                          \
                     background.drawing=off                        \
                     icon.padding_left=10                          \
                     icon="$sid"                                   \
                     click_script="aerospace workspace $sid"       \
                     drawing=off                                   \
                     script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done

for sid in $(aerospace list-workspaces --all); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')


  icon_strip=" "
  if [ "${apps}" != "" ]; then
  sketchybar --set space.$sid drawing=on
    while read -r app; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<<"${apps}"
  else
    icon_strip=""
  fi
  sketchybar --set space.$sid label="$icon_strip"
done

