#!/bin/bash
# Real OS Network Script
# Pragmatic Stage A migration - network operations via nmcli
# Usage: network.sh <action> [args]
# Actions: enable, disable, scan, connect <ssid>, disconnect <ssid>, list, status

ACTION="$1"
ARG="$2"

case "$ACTION" in
    enable)
        # Enable Wi-Fi
        nmcli radio wifi on
        ;;
    disable)
        # Disable Wi-Fi
        nmcli radio wifi off
        ;;
    scan)
        # Scan for networks
        nmcli device wifi list
        ;;
    connect)
        # Connect to network
        if [ -z "$ARG" ]; then
            echo "Error: SSID required for connect"
            exit 1
        fi
        nmcli device wifi connect "$ARG"
        ;;
    disconnect)
        # Disconnect from network
        if [ -z "$ARG" ]; then
            echo "Error: SSID required for disconnect"
            exit 1
        fi
        nmcli device wifi disconnect "$ARG"
        ;;
    list)
        # List available networks
        nmcli device wifi list
        ;;
    status)
        # Get connection status
        nmcli -t -f STATE,TYPE,CONNECTION device show
        ;;
    *)
        echo "Unknown action: $ACTION"
        echo "Usage: $0 <action> [args]"
        echo "Actions: enable, disable, scan, connect <ssid>, disconnect <ssid>, list, status"
        exit 1
        ;;
esac

exit 0
