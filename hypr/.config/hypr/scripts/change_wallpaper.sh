#!/bin/bash
# Usage: ./set_wallpaper.sh path/to/image.jpg

# 1. Set variables
IMAGE="${1:?Error: Provide an image path}"
IMAGE=$(realpath "$IMAGE")

# 2. Check existence and format 
if [[ ! -f "$IMAGE" || ! "$IMAGE" =~ \.(png|jpg|jpeg|webp|jxl)$ ]]; then
    echo "Error: File does not exist or format is unsupported."
    exit 1
fi

# 3. Apply wallpaper
hyprctl hyprpaper wallpaper ,$IMAGE

# 4. Overwrite config to make change permanent
# 'splash = false' is added to prevent the New Year text
cat > "$HOME/.config/hypr/config/hyprpaper.conf" <<EOF
ipc = true
splash = false

wallpaper {
    monitor = 
    path = $IMAGE
}
EOF

echo "Applied: ${IMAGE##*/}"
