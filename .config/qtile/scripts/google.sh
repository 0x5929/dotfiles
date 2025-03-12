#!/bin/bash
# google-search.sh

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for search query using rofi
query=$(rofi -dmenu -p "Google Search" -config ~/.config/rofi/config-google.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No search query entered"
    exit 1
fi

# URL encode the query for a web search
encoded_query=$(echo "$query" | sed 's/ /+/g')

# Google search URL
google_url="https://www.google.com/search?q=$encoded_query"

# Open the browser with the search URL
$BROWSER "$google_url"
