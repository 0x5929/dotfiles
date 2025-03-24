#!/bin/bash
# arch-package-search.sh

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for package name using rofi
query=$(rofi -dmenu -p "Icon Search" -config ~/.config/rofi/config-icons.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No Icon entered"
    exit 1
fi

# URL encode the query for a web search
encoded_query=$(echo "$query" | sed 's/ /+/g')

# Icon search URL
icon_search_url="https://symbl.cc/en/search/?q=$encoded_query"

# Open the browser with the search URL
$BROWSER "$icon_search_url"
