#!/bin/bash
# ~/.config/hypr/scripts/swww_parallax_effect.sh

# Listen for Hyprland workspace change events
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
  if echo "$line" | grep -q "^workspace>>"; then
    # Extract new workspace ID
    NEW_WS=$(echo "$line" | awk -F'>>' '{print $2}')
    echo "Switched to workspace: $NEW_WS"

    # Re-draw the CURRENT wallpaper with a smooth parallax-like transition
    # This makes it slide relative to the window movement
    # Adjust transition-type and duration for desired effect
    # Common types: grow, wipe, outer
    swww img "$(cat ~/.cache/swww/current_wallpaper)" \
        --transition-type grow \
        --transition-duration 0.4 \
        --transition-fps 60 \
        --transition-bezier 0.25,1.0,0.5,1.0 # Use a smooth bezier like winInSmooth

  elif echo "$line" | grep -q "^focusedmon>>"; then
    # If you switch monitor, ensure wallpaper is drawn with parallax effect too
    MON_NAME=$(echo "$line" | cut -d',' -f1 | awk -F'>>' '{print $2}')
    echo "Focused monitor: $MON_NAME"
    swww img "$(cat ~/.cache/swww/current_wallpaper)" \
        --transition-type grow \
        --transition-duration 0.4 \
        --transition-fps 60 \
        --transition-bezier 0.25,1.0,0.5,1.0 \
        --outputs "$MON_NAME"
  fi
done
