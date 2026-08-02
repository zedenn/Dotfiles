#!/bin/bash

# 1. Resolve path and validate
IMAGE="${1:?Error: No image provided}"
IMAGE=$(realpath "$IMAGE")

if [[ ! -f "$IMAGE" || ! "$IMAGE" =~ \.(png|jpg|jpeg|webp|jxl)$ ]]; then
    notify-send "Wallpaper Error" "Unsupported format"
    exit 1
fi

# 2. Update config for persistence
cat > "$HOME/.config/hypr/hyprpaper.conf" <<EOF
ipc = true
splash = false

wallpaper {
    monitor =
    path = $IMAGE
}
EOF

# 3. Optimized IPC logic
# Unload unused images to save RAM, then load the new one
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$IMAGE"
hyprctl hyprpaper wallpaper ",$IMAGE,"

notify-send -t 2000 "Hyprpaper" "Wallpaper: ${IMAGE##*/}"
