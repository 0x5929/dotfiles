#!/bin/bash
#   ___ _____ ___ _     _____   ____  _             _    
#  / _ \_   _|_ _| |   | ____| / ___|| |_ __ _ _ __| |_  
# | | | || |  | || |   |  _|   \___ \| __/ _` | '__| __| 
# | |_| || |  | || |___| |___   ___) | || (_| | |  | |_  
#  \__\_\|_| |___|_____|_____| |____/ \__\__,_|_|   \__| 
#                                                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# My screen resolution
# xrandr --rate 120

# For Virtual Machine 
# xrandr --output Virtual-1 --mode 1920x1080

xrandr --output DP-2 --mode 3840x1080 --primary --pos 0x0 --rate 119.97 --below DP-4 \
  --output DP-4 --mode 3440x1440 --pos 0x1080 --rate 99.98 \
  --output HDMI-0 --mode 1920x1080 --pos 3840x1440 --rate 60.00 --rotate left

# Keyboard layout
setxkbmap us

# Load picom
picom -b

# Load power manager
xfce4-power-manager &

# launch top bar
/home/kevin/.config/eww/bar/launch_bar_startup_th_bh_rv

# launch daemon for eww dashboard
# eww --config /home/kevin/.config/eww/dashboard daemon

# Load notification service
dunst &

# Setup Wallpaper and update colors
~/.config/qtile/scripts/wallpaper.sh init

# Load music into player
# ~/.config/qtile/scripts/add-music.sh

# Load screensavers (must be after wallpapers)
xscreensaver --no-splash
