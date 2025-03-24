#!/bin/bash

# Set the browser (you can change this to your preferred browser)
BROWSER="firefox"

# Prompt for search query using rofi
query=$(rofi -dmenu -p "Reddit Search" -config ~/.config/rofi/config-reddit.rasi)

# Check if the search query is empty
if [ -z "$query" ]; then
    echo "No search query entered"
    exit 1
fi

# URL encode the query for a web search
# This simple replacement handles spaces, but a more complete solution might be needed for special characters
encoded_query=$(echo "$query" | sed 's/ /+/g')

# YouTube search URL
reddit_url="https://www.reddit.com/search/?q=$encoded_query&type=posts&sort=hot"

# Open the browser with the search URL
$BROWSER "$reddit_url"
