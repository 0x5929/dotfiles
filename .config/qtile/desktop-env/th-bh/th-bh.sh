#!/bin/bash
xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal \
       --output DP-1 --mode 1920x1080 --primary --pos 0x1080 --rotate inverted
exec qtile start --config /home/kevin/.config/qtile/desktop-env/th-bh/config-th-bh.py
