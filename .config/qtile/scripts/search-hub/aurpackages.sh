#!/bin/bash
# arch-package-search.sh

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for package name using rofi
query=$(rofi -dmenu -p "Arch Package Search" -config ~/.config/rofi/config-aurpackages.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No package name entered"
    exit 1
fi

# URL encode the query for a web search
encoded_query=$(echo "$query" | sed 's/ /+/g')

# Arch Linux package search URL
aur_pkg_url="https://aur.archlinux.org/packages?O=0&K=$encoded_query"

# Open the browser with the search URL
$BROWSER "$aur_pkg_url"
