#!/bin/bash
# Real OS Power Script
# Pragmatic Stage A migration - power operations via systemd
# Usage: power.sh <action>
# Actions: lock, logout, suspend, hibernate, restart, shutdown

ACTION="$1"

case "$ACTION" in
    lock)
        # Lock screen using loginctl
        loginctl lock-session
        ;;
    logout)
        # Terminate user session
        loginctl terminate-user "$USER"
        ;;
    suspend)
        # Suspend system
        systemctl suspend
        ;;
    hibernate)
        # Hibernate system
        systemctl hibernate
        ;;
    restart)
        # Restart system
        systemctl reboot
        ;;
    shutdown)
        # Shutdown system
        systemctl poweroff
        ;;
    *)
        echo "Unknown action: $ACTION"
        echo "Usage: $0 <action>"
        echo "Actions: lock, logout, suspend, hibernate, restart, shutdown"
        exit 1
        ;;
esac

exit 0
