#!/bin/bash
# arch-package-search.sh

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for package name using rofi
query=$(rofi -dmenu -p "Arch Package Search" -config ~/.config/rofi/config-archpackages.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No package name entered"
    exit 1
fi

# URL encode the query for a web search
encoded_query=$(echo "$query" | sed 's/ /+/g')

# Arch Linux package search URL
arch_pkg_url="https://archlinux.org/packages/?q=$encoded_query"

# Open the browser with the search URL
$BROWSER "$arch_pkg_url"
