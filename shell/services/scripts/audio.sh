#!/bin/bash
# Real OS Audio Script
# Pragmatic Stage A migration - audio operations via pactl (PipeWire/PulseAudio)
# Usage: audio.sh <action> [args]
# Actions: set-volume <percentage>, mute, unmute, set-output <device>, set-input <device>, get-volume, get-mute, list-outputs, list-inputs, get-default-output, get-default-input

ACTION="$1"
ARG="$2"

case "$ACTION" in
    set-volume)
        # Set volume (0-100)
        if [ -z "$ARG" ]; then
            echo "Error: Percentage required for set-volume"
            exit 1
        fi
        pactl set-sink-volume @DEFAULT_SINK@ "${ARG}%"
        ;;
    mute)
        # Mute output
        pactl set-sink-mute @DEFAULT_SINK@ true
        ;;
    unmute)
        # Unmute output
        pactl set-sink-mute @DEFAULT_SINK@ false
        ;;
    set-output)
        # Set default output device
        if [ -z "$ARG" ]; then
            echo "Error: Device ID required for set-output"
            exit 1
        fi
        pactl set-default-sink "$ARG"
        ;;
    set-input)
        # Set default input device
        if [ -z "$ARG" ]; then
            echo "Error: Device ID required for set-input"
            exit 1
        fi
        pactl set-default-source "$ARG"
        ;;
    get-volume)
        # Get current volume
        pactl get-sink-volume @DEFAULT_SINK@
        ;;
    get-mute)
        # Get mute state
        pactl get-sink-mute @DEFAULT_SINK@
        ;;
    list-outputs)
        # List output devices
        pactl list sinks short
        ;;
    list-inputs)
        # List input devices
        pactl list sources short
        ;;
    get-default-output)
        # Get default output device
        pactl get-default-sink
        ;;
    get-default-input)
        # Get default input device
        pactl get-default-source
        ;;
    *)
        echo "Unknown action: $ACTION"
        echo "Usage: $0 <action> [args]"
        echo "Actions: set-volume <percentage>, mute, unmute, set-output <device>, set-input <device>, get-volume, get-mute, list-outputs, list-inputs, get-default-output, get-default-input"
        exit 1
        ;;
esac

exit 0
