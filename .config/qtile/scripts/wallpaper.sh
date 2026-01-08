#!/bin/bash

export PATH="/home/kevin/.local/bin/:$PATH"

LOG_DIR="$HOME/.cache/wallpaper"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/wallpaper.log"

# Log everything (including stderr)
exec >>"$LOG_FILE" 2>&1

# Add timestamps to xtrace
export PS4='+ $(date "+%F %T") [${BASH_SOURCE##*/}:${LINENO}] '
set -x

echo "-----"
echo "START args=$* pid=$$"
echo "USER=$USER HOME=$HOME SHELL=$SHELL"
echo "XDG_SESSION_TYPE=$XDG_SESSION_TYPE DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
echo "PATH=$PATH"
echo "which: wal=$(command -v wal || echo MISSING) feh=$(command -v feh || echo MISSING) magick=$(command -v magick || echo MISSING) rofi=$(command -v rofi || echo MISSING) qtile=$(command -v qtile || echo MISSING)"
#   ____ _                              _____ _
#  / ___| |__   __ _ _ __   __ _  ___  |_   _| |__   ___ _ __ ___   ___
# | |   | '_ \ / _` | '_ \ / _` |/ _ \   | | | '_ \ / _ \ '_ ` _ \ / _ \
# | |___| | | | (_| | | | | (_| |  __/   | | | | | |  __/ | | | | |  __/
#  \____|_| |_|\__,_|_| |_|\__, |\___|   |_| |_| |_|\___|_| |_| |_|\___|
#                          |___/
#
# by Stephan Raabe (2023)
# -----------------------------------------------------

# Cache file for holding the current wallpaper
wallpaper_folder="$HOME/Pictures/wallpaper"
if [ -f ~/.config/qtile/scripts/wallpaper-folder.sh ]; then
  source ~/.config/qtile/scripts/wallpaper-folder.sh
fi
cache_file="$HOME/.cache/wallpaper/current_wallpaper"
blurred="$HOME/.cache/wallpaper/blurred_wallpaper.png"
rasi_file="$HOME/.cache/wallpaper/current_wallpaper.rasi"

# Create cache file if not exists
if [ ! -f $cache_file ]; then
  touch $cache_file
  echo "$wallpaper_folder/default.jpg" >"$cache_file"
fi

# Create rasi file if not exists
if [ ! -f $rasi_file ]; then
  touch $rasi_file
  echo "* { current-image: url(\"$wallpaper_folder/default.jpg\", height); }" >"$rasi_file"
fi

current_wallpaper=$(cat "$cache_file")

case $1 in

# Load wallpaper from .cache of last session
"init")
  if [ -f $cache_file ]; then
    wal -q -i $current_wallpaper
  else
    wal -q -i $wallpaper_folder
  fi
  ;;

# Select wallpaper with rofi
"select")
  selected=$(find "$wallpaper_folder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec basename {} \; | sort -R | while read rfile; do
    echo -en "$rfile\x00icon\x1f$wallpaper_folder/${rfile}\n"
  done | rofi -dmenu -replace -l 6 -config ~/.config/rofi/config-wallpaper.rasi)
  if [ ! "$selected" ]; then
    echo "No wallpaper selected"
    exit
  fi
  wal -q -i $wallpaper_folder/$selected
  ;;

# Randomly select wallpaper
*)
  wal -q -i $wallpaper_folder/
  ;;

esac

# -----------------------------------------------------
# Reload qtile to color bar
# -----------------------------------------------------
qtile cmd-obj -o cmd -f reload_config

# -----------------------------------------------------
# Get new theme
# -----------------------------------------------------
source "$HOME/.cache/wal/colors.sh"
echo "Wallpaper: $wallpaper"
# newwall=$(echo $wallpaper | sed "s|$HOME/wallpaper/||g")
newwall="${wallpaper#$HOME/Pictures/wallpaper/}"

# -----------------------------------------------------
# Created blurred wallpaper
# -----------------------------------------------------
magick $wallpaper -resize 50% $blurred
echo ":: Resized to 50%"
magick $blurred -blur 50x30 $blurred
echo ":: Blurred"
# -----------------------------------------------------
# Write selected wallpaper into .cache files
# -----------------------------------------------------
echo "$wallpaper" >"$cache_file"
echo "* { current-image: url(\"$blurred\", height); }" >"$rasi_file"

sleep 1

# -----------------------------------------------------
# Send notification
# -----------------------------------------------------
notify-send "Colors and Wallpaper updated" "with image $newwall"
echo "Done."
