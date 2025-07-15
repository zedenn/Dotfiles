#!/bin/bash
IMAGE="$1"
CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Resolve full path
IMAGE="$(realpath "$IMAGE")"

# Validate supported formats
EXT="${IMAGE##*.}"
if ! [[ "$EXT" =~ ^(png|jpg|jpeg|webp|jxl)$ ]]; then
    echo "Unsupported format: .$EXT"
    echo "Supported formats: png, jpg, jpeg, webp, jxl"
    exit 1
fi

# Unload existing wallpapers
hyprctl hyprpaper unload all >/dev/null

# Apply wallpaper to all monitors
hyprctl hyprpaper reload ",$IMAGE" >/dev/null

# Save config for persistence
echo "preload=$IMAGE" > "$CONFIG"
echo "wallpaper=,$IMAGE" >> "$CONFIG"
echo "ipc=true" >> "$CONFIG"

# Confirmation message
echo "Wallpaper set to: $(basename "$IMAGE")"
