#!/bin/bash
# Real OS Brightness Script
# Pragmatic Stage A migration - brightness operations via /sys/class/backlight
# Usage: brightness.sh <action> [args]
# Actions: get, set <percentage>

ACTION="$1"
ARG="$2"

# Find backlight device
BACKLIGHT_DIR="/sys/class/backlight"
BACKLIGHT_DEVICE=$(ls "$BACKLIGHT_DIR" 2>/dev/null | head -n 1)

if [ -z "$BACKLIGHT_DEVICE" ]; then
    echo "Error: No backlight device found"
    exit 1
fi

BACKLIGHT_PATH="$BACKLIGHT_DIR/$BACKLIGHT_DEVICE"
MAX_BRIGHTNESS=$(cat "$BACKLIGHT_PATH/max_brightness")

case "$ACTION" in
    get)
        # Get current brightness percentage
        CURRENT_BRIGHTNESS=$(cat "$BACKLIGHT_PATH/brightness")
        PERCENTAGE=$((CURRENT_BRIGHTNESS * 100 / MAX_BRIGHTNESS))
        echo "$PERCENTAGE"
        ;;
    set)
        # Set brightness (0-100)
        if [ -z "$ARG" ]; then
            echo "Error: Percentage required for set"
            exit 1
        fi
        # Clamp percentage to 0-100
        PERCENTAGE=$((ARG < 0 ? 0 : ARG > 100 ? 100 : ARG))
        NEW_BRIGHTNESS=$((PERCENTAGE * MAX_BRIGHTNESS / 100))
        echo "$NEW_BRIGHTNESS" | sudo tee "$BACKLIGHT_PATH/brightness" > /dev/null
        ;;
    *)
        echo "Unknown action: $ACTION"
        echo "Usage: $0 <action> [args]"
        echo "Actions: get, set <percentage>"
        exit 1
        ;;
esac

exit 0
