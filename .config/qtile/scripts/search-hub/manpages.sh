#!/bin/bash

cache_file="$HOME/.cache/wallpaper/current_wallpaper"

# Create cache file if not exists
if [ ! -f $cache_file ] ;then
    touch $cache_file
    echo "$wallpaper_folder/default.jpg" > "$cache_file"
fi

manpages=$(man -k . | sort)
selected=$(echo "$manpages" | rofi -dmenu -i -p "Man Pages" -config ~/.config/rofi/config-man.rasi)

# Check if a selection was made
if [ -z "$selected" ]; then
    echo "No man page selected"
    exit 1
fi

# Extract the command name from the selection (it's before the first dash)
command=$(echo "$selected" | awk -F' - ' '{print $1}' | awk '{print $1}')

# Open the selected man page in Alacritty
alacritty -e man "$command"
