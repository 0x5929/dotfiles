#!/bin/bash
# Path to your search scripts directory
SCRIPTS_DIR="$HOME/.config/qtile/scripts/search-hub"

# Define options with icons (using Nerd Font icons)
options=(
    "📚 Man Pages - man"
    "📖 Arch Wiki - arch wiki"
    "📺 YouTube - youtube"
    "🔍 Google - google"
    "🗨️ Reddit - reddit"
    "📝 GitHub - github"
    "📦 Arch Packages - arch packages pacman"
    "🎁 AUR Packages - aur packages yay"
)

# Define corresponding scripts
scripts=(
    "manpages.sh"
    "archwiki.sh"
    "youtube.sh" 
    "google.sh"
    "reddit.sh"
    "github.sh"
    "archpackages.sh"
    "aurpackages.sh"
)

# Define search titles 
titles=(
    "Man Pages"
    "Arch Wiki"
    "YouTube"
    "Google"
    "Reddit"
    "GitHub"
    "Arch Packages"
    "AUR Packages"
)

# Show menu with rofi using the specific configuration
selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Search" -config ~/.config/rofi/config-hub.rasi)

# Extract the label part (between the emoji and the " - ")
selected_label=$(echo "$selected" | cut -d'-' -f1 | sed 's/^[^[:alnum:]]*//' | xargs)

# Find the index of the selected option
index=-1
for i in "${!titles[@]}"; do
    if [[ "${titles[$i]}" = "${selected_label}" ]]; then
        index=$i
        break
    fi
done

# If a valid option was selected, execute the corresponding script
if [[ $index -ge 0 ]]; then
    script_path="$SCRIPTS_DIR/${scripts[$index]}"
    title="${titles[$index]}"
    
    # Check if the script exists and is executable
    if [[ -x "$script_path" ]]; then
        # Pass the title as an argument to the script
        "$script_path"
    else
        notify-send "Error" "Script not found or not executable: $script_path"
        exit 1
    fi
else
    # No selection made
    exit 0
fi
