#!/bin/bash
#
# Real Shell Doctor
# Diagnostics and troubleshooting tool for Real Shell
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# XDG directories
CONFIG_DIR="$HOME/.config/real-shell"
DATA_DIR="$HOME/.local/share/real-shell"
STATE_DIR="$HOME/.local/state/real-shell"
CACHE_DIR="$HOME/.cache/real-shell"
PID_FILE="$STATE_DIR/runtime/real-shell.pid"

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to check item
check_item() {
    local name=$1
    local status=$2
    local message=$3
    
    case $status in
        ok)
            echo -e "${GREEN}✓${NC} $name"
            ;;
        warning)
            echo -e "${YELLOW}⚠${NC} $name - $message"
            ;;
        error)
            echo -e "${RED}✗${NC} $name - $message"
            ;;
    esac
}

# Main diagnostics routine
main() {
    print_header "Real Shell Doctor"
    
    local warnings=0
    local errors=0
    
    # Environment
    print_header "Environment"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        check_item "OS" "ok" "$PRETTY_NAME"
    else
        check_item "OS" "error" "Cannot detect OS"
        ((errors++))
    fi
    
    if [ -n "$WAYLAND_DISPLAY" ]; then
        check_item "Wayland session" "ok" "$WAYLAND_DISPLAY"
    else
        check_item "Wayland session" "warning" "Not in Wayland session"
        ((warnings++))
    fi
    
    if command -v Hyprland &> /dev/null; then
        check_item "Hyprland" "ok" "Installed"
    else
        check_item "Hyprland" "error" "Not installed"
        ((errors++))
    fi
    
    # Quickshell
    print_header "Quickshell"
    
    if command -v quickshell &> /dev/null; then
        check_item "Quickshell" "ok" "Installed"
    else
        check_item "Quickshell" "error" "Not installed"
        ((errors++))
    fi
    
    # System Services
    print_header "System Services"
    
    if systemctl is-active --quiet systemd; then
        check_item "systemd" "ok" "Running"
    else
        check_item "systemd" "error" "Not running"
        ((errors++))
    fi
    
    if systemctl is-active --quiet NetworkManager; then
        check_item "NetworkManager" "ok" "Running"
    else
        check_item "NetworkManager" "warning" "Not running"
        ((warnings++))
    fi
    
    if systemctl is-active --quiet pipewire; then
        check_item "PipeWire" "ok" "Running"
    else
        check_item "PipeWire" "warning" "Not running"
        ((warnings++))
    fi
    
    if systemctl is-active --quiet bluetooth; then
        check_item "BlueZ" "ok" "Running"
    else
        check_item "BlueZ" "warning" "Not running"
        ((warnings++))
    fi
    
    # D-Bus Services
    print_header "D-Bus Services"
    
    if dbus-send --system --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q "org.freedesktop.NetworkManager"; then
        check_item "NetworkManager D-Bus" "ok" "Available"
    else
        check_item "NetworkManager D-Bus" "warning" "Not available"
        ((warnings++))
    fi
    
    if dbus-send --system --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q "org.bluez"; then
        check_item "BlueZ D-Bus" "ok" "Available"
    else
        check_item "BlueZ D-Bus" "warning" "Not available"
        ((warnings++))
    fi
    
    # Real Shell Configuration
    print_header "Real Shell Configuration"
    
    if [ -d "$CONFIG_DIR" ]; then
        check_item "Config directory" "ok" "$CONFIG_DIR"
    else
        check_item "Config directory" "error" "Not found: $CONFIG_DIR"
        ((errors++))
    fi
    
    if [ -f "$CONFIG_DIR/settings/settings.json" ]; then
        check_item "Settings file" "ok" "Exists"
    else
        check_item "Settings file" "warning" "Not found"
        ((warnings++))
    fi
    
    if [ -f "$CONFIG_DIR/quickshell/config.json" ]; then
        check_item "Quickshell config" "ok" "Exists"
    else
        check_item "Quickshell config" "warning" "Not found"
        ((warnings++))
    fi
    
    # Runtime State
    print_header "Runtime State"
    
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            check_item "Real Shell process" "ok" "Running (PID: $pid)"
        else
            check_item "Real Shell process" "error" "Stale PID file"
            ((errors++))
        fi
    else
        check_item "Real Shell process" "warning" "Not running"
        ((warnings++))
    fi
    
    # Logs
    print_header "Logs"
    
    if [ -f "$STATE_DIR/logs/shell/quickshell.log" ]; then
        check_item "Quickshell log" "ok" "Exists"
    else
        check_item "Quickshell log" "warning" "Not found"
        ((warnings++))
    fi
    
    # Project Structure
    print_header "Project Structure"
    
    if [ -d "$PROJECT_DIR/shell" ]; then
        check_item "Shell directory" "ok" "Exists"
    else
        check_item "Shell directory" "error" "Not found"
        ((errors++))
    fi
    
    if [ -f "$PROJECT_DIR/shell.qml" ]; then
        check_item "shell.qml" "ok" "Exists"
    else
        check_item "shell.qml" "error" "Not found"
        ((errors++))
    fi
    
    if [ -f "$PROJECT_DIR/qmldir" ]; then
        check_item "qmldir" "ok" "Exists"
    else
        check_item "qmldir" "warning" "Not found"
        ((warnings++))
    fi
    
    # Summary
    print_header "Summary"
    
    echo -e "Warnings: ${YELLOW}$warnings${NC}"
    echo -e "Errors:   ${RED}$errors${NC}"
    
    if [ $errors -gt 0 ]; then
        echo -e "\n${RED}Critical issues found. Please address them before Real Shell can run properly.${NC}"
        return 1
    elif [ $warnings -gt 0 ]; then
        echo -e "\n${YELLOW}Some warnings found. Real Shell may have limited functionality.${NC}"
        return 0
    else
        echo -e "\n${GREEN}No issues found. Real Shell should run properly.${NC}"
        return 0
    fi
}

# Run main function
main "$@"
