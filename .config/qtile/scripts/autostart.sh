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

# Keyboard layout
setxkbmap us

# Load picom
picom -b

# Load power manager
xfce4-power-manager &

# launch top bar
/home/kevin/.config/eww/bar/launch_bar_startup

# launch daemon for eww dashboard
eww --config /home/kevin/.config/eww/dashboard daemon

# Load notification service
dunst &

# Setup Wallpaper and update colors
~/.config/qtile/scripts/wallpaper.sh init
