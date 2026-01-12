#!/bin/bash

xrandr \
  --output DP-3 --mode 3440x1440 --pos 0x0 --rotate normal \
  --output DP-2 --primary --mode 3840x1080 --pos 0x1440 --rotate normal \
  --output HDMI-1 --mode 1920x1080 --pos 3840x0 --rotate left

exec qtile start --config /home/kevin/.config/qtile/desktop-env/th-bh-rv/config-th-bh-rv.py
