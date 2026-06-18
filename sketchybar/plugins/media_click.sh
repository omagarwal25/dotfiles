#!/bin/bash

case "$BUTTON" in
  "right") nowplaying-cli next ;;
  "left")  nowplaying-cli togglePlayPause ;;
esac
