#!/bin/bash
# xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal \
#   --output DP-1 --mode 1920x1080 --primary --pos 0x1080 --rotate inverted \
#   --output HDMI-1-0 --mode 1920x1080 --pos 1920x0 --rotate left
#
# xrandr \
#   --output DP-3 --mode 3440x1440 --rate 99.98 --pos 200x0 --rotate normal \
#   --output DP-2 --mode 3840x1080 --rate 119.97 --primary --pos 0x1440 --rotate normal \
#   --output HDMI-1 --mode 1920x1080 --rate 60.00 --pos 3840x600 --rotate left \
#   --output DP-1 --off

# CORRECT:
# xrandr \
#   --output DP-3 --mode 1920x1080 --pos 0x0 --rotate normal \
#   --output DP-2 --mode 1920x1080 --primary --pos 0x1080 --rotate normal \
#   --output HDMI-1 --mode 1920x1080 --pos 1920x0 --rotate left \
#   --output DP-1 --off
# xrandr \
#   --output DP-2 --mode 3840x1080 --rate 119.97 --primary --pos 0x840 --rotate normal \
#   --output DP-3 --mode 3440x1440 --rate 99.98 --pos 3840x480 --rotate normal \
#   --output HDMI-1 --mode 1920x1080 --rate 60.00 --pos 7280x0 --rotate left \
#   --output DP-1 --off
#
# xrandr \
#   --output DP-3 --mode 3440x1440 --rate 99.98 --pos 0x0 --rotate normal \
#   --output DP-2 --mode 3840x1080 --rate 119.97 --primary --pos 0x1440 --rotate normal \
#   --output HDMI-1 --mode 1920x1080 --rate 60.00 --pos 3840x0 --rotate left \
#   --output DP-1 --off
# xrandr \
#   --output DP-3 --mode 3440x1440 --rate 99.98 --pos 0x0 --rotate normal \
#   --output DP-2 --mode 3840x1080 --rate 119.97 --primary --pos 0x1440 --rotate normal \
#   --output HDMI-1 --mode 1920x1080 --rate 60.00 --pos 3840x0 --rotate left \
#   --output DP-1 --off
#
exec qtile start --config /home/kevin/.config/qtile/desktop-env/th-bh-rv/config-th-bh-rv.py
