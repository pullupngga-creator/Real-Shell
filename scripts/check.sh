#!/bin/bash
#
# Real Shell Environment Checker
# Checks system requirements for Real Shell deployment
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check results
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to check a binary
check_binary() {
    local name=$1
    local binary=$2
    local required=$3
    
    if command -v "$binary" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name"
        ((CHECKS_PASSED++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $name (required)"
            ((CHECKS_FAILED++))
            return 1
        else
            echo -e "${YELLOW}⚠${NC} $name (optional)"
            ((CHECKS_WARNING++))
            return 2
        fi
    fi
}

# Function to check a systemd service
check_service() {
    local name=$1
    local service=$2
    local required=$3
    
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $name (running)"
        ((CHECKS_PASSED++))
        return 0
    elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
        echo -e "${YELLOW}⚠${NC} $name (enabled but not running)"
        ((CHECKS_WARNING++))
        return 2
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $name (required)"
            ((CHECKS_FAILED++))
            return 1
        else
            echo -e "${YELLOW}⚠${NC} $name (optional)"
            ((CHECKS_WARNING++))
            return 2
        fi
    fi
}

# Function to check a D-Bus service
check_dbus() {
    local name=$1
    local service=$2
    local required=$3
    
    if dbus-send --system --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames 2>/dev/null | grep -q "$service"; then
        echo -e "${GREEN}✓${NC} $name (D-Bus available)"
        ((CHECKS_PASSED++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $name (required)"
            ((CHECKS_FAILED++))
            return 1
        else
            echo -e "${YELLOW}⚠${NC} $name (optional)"
            ((CHECKS_WARNING++))
            return 2
        fi
    fi
}

# Function to check a directory
check_directory() {
    local name=$1
    local path=$2
    local required=$3
    
    if [ -d "$path" ]; then
        echo -e "${GREEN}✓${NC} $name ($path)"
        ((CHECKS_PASSED++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $name (required: $path)"
            ((CHECKS_FAILED++))
            return 1
        else
            echo -e "${YELLOW}⚠${NC} $name (optional: $path)"
            ((CHECKS_WARNING++))
            return 2
        fi
    fi
}

# Main check routine
main() {
    print_header "Real Shell Environment Check"
    
    # Operating System
    print_header "Operating System"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "arch" ] || [ "$ID" = "archlinux" ]; then
            echo -e "${GREEN}✓${NC} Arch Linux ($PRETTY_NAME)"
            ((CHECKS_PASSED++))
        else
            echo -e "${YELLOW}⚠${NC} $PRETTY_NAME (Arch Linux recommended)"
            ((CHECKS_WARNING++))
        fi
    else
        echo -e "${RED}✗${NC} Cannot detect OS"
        ((CHECKS_FAILED++))
    fi
    
    # Desktop Session
    print_header "Desktop Session"
    
    check_binary "Wayland" "wayland" "required"
    
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo -e "${GREEN}✓${NC} Wayland session active ($WAYLAND_DISPLAY)"
        ((CHECKS_PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} Not running in Wayland session"
        ((CHECKS_WARNING++))
    fi
    
    check_binary "Hyprland" "Hyprland" "required"
    
    # System Services
    print_header "System Services"
    
    check_service "systemd" "systemd" "required"
    check_dbus "D-Bus system" "org.freedesktop.DBus" "required"
    check_dbus "D-Bus session" "org.freedesktop.DBus" "required"
    
    # Network Services
    print_header "Network Services"
    
    check_service "NetworkManager" "NetworkManager" "required"
    check_dbus "NetworkManager D-Bus" "org.freedesktop.NetworkManager" "required"
    
    # Audio Services
    print_header "Audio Services"
    
    check_service "PipeWire" "pipewire" "required"
    check_service "PipeWire Pulse" "pipewire-pulse" "required"
    check_dbus "PipeWire D-Bus" "org.freedesktop.portal.Desktop" "optional"
    
    # Bluetooth Services
    print_header "Bluetooth Services"
    
    check_service "BlueZ" "bluetooth" "optional"
    check_dbus "BlueZ D-Bus" "org.bluez" "optional"
    
    # Quickshell
    print_header "Quickshell"
    
    check_binary "Quickshell" "quickshell" "required"
    
    # Required Utilities
    print_header "Required Utilities"
    
    check_binary "brightnessctl" "brightnessctl" "required"
    check_binary "pamixer" "pamixer" "optional"
    check_binary "playerctl" "playerctl" "optional"
    check_binary "jq" "jq" "required"
    
    # Development Tools (optional)
    print_header "Development Tools (Optional)"
    
    check_binary "git" "git" "optional"
    check_binary "npm" "npm" "optional"
    check_binary "node" "node" "optional"
    
    # Directory Structure
    print_header "Directory Structure"
    
    check_directory "XDG config" "$HOME/.config" "required"
    check_directory "XDG data" "$HOME/.local/share" "required"
    check_directory "XDG cache" "$HOME/.cache" "required"
    check_directory "XDG state" "$HOME/.local/state" "optional"
    
    # Summary
    print_header "Summary"
    
    echo -e "Passed: ${GREEN}$CHECKS_PASSED${NC}"
    echo -e "Warnings: ${YELLOW}$CHECKS_WARNING${NC}"
    echo -e "Failed: ${RED}$CHECKS_FAILED${NC}"
    
    if [ $CHECKS_FAILED -gt 0 ]; then
        echo -e "\n${RED}Environment check failed. Please install missing dependencies.${NC}"
        return 1
    elif [ $CHECKS_WARNING -gt 0 ]; then
        echo -e "\n${YELLOW}Environment check passed with warnings. Some features may be limited.${NC}"
        return 0
    else
        echo -e "\n${GREEN}Environment check passed. All requirements met.${NC}"
        return 0
    fi
}

# Run main function
main "$@"
