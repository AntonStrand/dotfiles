#!/bin/zshh
# This script will look for any other application window to focus on if the current one is destroyed.

# Get the id of the focused window
currentFocusedWindow=$(yabai -m query --windows --window | jq -re '.id')

# If the current focused window is destroyed, focus on the next available window
if [[ -z "$currentFocusedWindow" ]]; then
	nextAvailableWindow=$(yabai -m query --windows | jq -re '.[] | select(.["is-visible"] and .["has-focus"] == false).id' | head -n 1)
	yabai -m window --focus $nextAvailableWindow
fi
