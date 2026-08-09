#!/bin/bash
#
# Real Shell Uninstall Script
# Removes Real Shell configuration and state (not source code)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to confirm action
confirm() {
    local message=$1
    echo -e "${YELLOW}$message${NC}"
    read -p "Continue? (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Main uninstall routine
main() {
    print_header "Real Shell Uninstall"
    
    echo -e "${RED}WARNING: This will remove Real Shell configuration and state.${NC}"
    echo -e ""
    echo -e "${YELLOW}This will remove:${NC}"
    echo -e "  - Configuration files"
    echo -e "  - Runtime state"
    echo -e "  - Logs"
    echo -e "  - Cache"
    echo -e "  - Data files"
    echo -e ""
    echo -e "${YELLOW}This will NOT remove:${NC}"
    echo -e "  - Source code (repository)"
    echo -e "  - Installed packages (Quickshell, etc.)"
    echo -e "  - System dependencies"
    
    if ! confirm "Uninstall Real Shell?"; then
        echo -e "${YELLOW}Uninstall cancelled${NC}"
        exit 0
    fi
    
    # Stop Real Shell if running
    print_header "Stopping Real Shell"
    
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${GREEN}→${NC} Stopping Real Shell..."
            kill "$pid" 2>/dev/null || true
            sleep 2
            if ps -p "$pid" > /dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
            rm -f "$PID_FILE"
            echo -e "${GREEN}✓${NC} Real Shell stopped"
        else
            rm -f "$PID_FILE"
            echo -e "${GREEN}✓${NC} Real Shell was not running"
        fi
    else
        echo -e "${GREEN}✓${NC} Real Shell was not running"
    fi
    
    # Remove configuration directory
    print_header "Removing Configuration"
    
    if [ -d "$CONFIG_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing config directory: $CONFIG_DIR"
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN}✓${NC} Configuration removed"
    else
        echo -e "${GREEN}✓${NC} Configuration does not exist"
    fi
    
    # Remove data directory
    print_header "Removing Data"
    
    if [ -d "$DATA_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing data directory: $DATA_DIR"
        rm -rf "$DATA_DIR"
        echo -e "${GREEN}✓${NC} Data removed"
    else
        echo -e "${GREEN}✓${NC} Data does not exist"
    fi
    
    # Remove state directory
    print_header "Removing State"
    
    if [ -d "$STATE_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing state directory: $STATE_DIR"
        rm -rf "$STATE_DIR"
        echo -e "${GREEN}✓${NC} State removed"
    else
        echo -e "${GREEN}✓${NC} State does not exist"
    fi
    
    # Remove cache directory
    print_header "Removing Cache"
    
    if [ -d "$CACHE_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing cache directory: $CACHE_DIR"
        rm -rf "$CACHE_DIR"
        echo -e "${GREEN}✓${NC} Cache removed"
    else
        echo -e "${GREEN}✓${NC} Cache does not exist"
    fi
    
    # Remove Hyprland integration
    print_header "Removing Hyprland Integration"
    
    local hyprland_config="$HOME/.config/hypr/hyprland.conf"
    if [ -f "$hyprland_config" ]; then
        if grep -q "real-shell" "$hyprland_config"; then
            echo -e "${YELLOW}→${NC} Removing Real Shell integration from Hyprland config"
            # Remove the Real Shell source line
            sed -i '/real-shell/d' "$hyprland_config"
            echo -e "${GREEN}✓${NC} Hyprland integration removed"
        else
            echo -e "${GREEN}✓${NC} No Hyprland integration found"
        fi
    else
        echo -e "${GREEN}✓${NC} Hyprland config not found"
    fi
    
    # Summary
    print_header "Uninstall Complete"
    
    echo -e "${GREEN}Real Shell has been uninstalled.${NC}"
    echo -e "\nTo completely remove Real Shell:"
    echo -e "  1. Delete the source code repository"
    echo -e "  2. Manually remove installed packages if desired"
    echo -e ""
    echo -e "To reinstall Real Shell:"
    echo -e "  1. Clone the repository"
    echo -e "  2. Run ${BLUE}./scripts/setup.sh${NC}"
}

# Run main function
main "$@"
