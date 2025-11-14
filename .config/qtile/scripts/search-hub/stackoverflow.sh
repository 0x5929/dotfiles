#!/bin/bash
# github-search.sh

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for search query using rofi
query=$(rofi -dmenu -p "Stackoverflow Search" -config ~/.config/rofi/config-stackoverflow.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No search query entered"
    exit 1
fi

# URL encode the query for a web search
encoded_query=$(echo "$query" | sed 's/ /+/g')

# stackoverflow search URL
stackoverflow_url="https://stackoverflow.com/search?q=$encoded_query"

# Open the browser with the search URL
$BROWSER "$stackoverflow_url"
