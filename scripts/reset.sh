#!/bin/bash
#
# Real Shell Reset Script
# Resets Real Shell state without removing configuration or source code
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

# Main reset routine
main() {
    print_header "Real Shell Reset"
    
    echo -e "${YELLOW}This will reset Real Shell state including:${NC}"
    echo -e "  - Runtime state"
    echo -e "  - Logs"
    echo -e "  - Cache"
    echo -e "  - Temporary files"
    echo -e ""
    echo -e "${YELLOW}This will NOT remove:${NC}"
    echo -e "  - Configuration files"
    echo -e "  - Source code"
    echo -e "  - User settings"
    
    if ! confirm "Reset Real Shell state?"; then
        echo -e "${YELLOW}Reset cancelled${NC}"
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
    
    # Reset state directory
    print_header "Resetting State Directory"
    
    if [ -d "$STATE_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing state directory: $STATE_DIR"
        rm -rf "$STATE_DIR"
        echo -e "${GREEN}✓${NC} State directory removed"
    else
        echo -e "${GREEN}✓${NC} State directory does not exist"
    fi
    
    # Reset cache directory
    print_header "Resetting Cache Directory"
    
    if [ -d "$CACHE_DIR" ]; then
        echo -e "${YELLOW}→${NC} Removing cache directory: $CACHE_DIR"
        rm -rf "$CACHE_DIR"
        echo -e "${GREEN}✓${NC} Cache directory removed"
    else
        echo -e "${GREEN}✓${NC} Cache directory does not exist"
    fi
    
    # Recreate directories
    print_header "Recreating Directories"
    
    mkdir -p "$STATE_DIR/logs/shell"
    mkdir -p "$STATE_DIR/logs/services"
    mkdir -p "$STATE_DIR/logs/backends"
    mkdir -p "$STATE_DIR/runtime"
    mkdir -p "$CACHE_DIR/icons"
    mkdir -p "$CACHE_DIR/thumbnails"
    
    echo -e "${GREEN}✓${NC} Directories recreated"
    
    # Reset runtime state
    print_header "Resetting Runtime State"
    
    local runtime_state='{
  "sessionId": null,
  "startTime": null,
  "lastActivity": null,
  "services": {},
  "backends": {}
}'
    
    echo "$runtime_state" > "$STATE_DIR/runtime/state.json"
    echo -e "${GREEN}✓${NC} Runtime state reset"
    
    # Set permissions
    print_header "Setting Permissions"
    
    chmod 755 "$STATE_DIR"
    chmod 755 "$STATE_DIR/logs"
    chmod 755 "$STATE_DIR/runtime"
    chmod 755 "$CACHE_DIR"
    
    echo -e "${GREEN}✓${NC} Permissions set"
    
    # Summary
    print_header "Reset Complete"
    
    echo -e "${GREEN}Real Shell state has been reset.${NC}"
    echo -e "\nConfiguration preserved:"
    echo -e "  Config: ${BLUE}$CONFIG_DIR${NC}"
    echo -e "  Data:   ${BLUE}$DATA_DIR${NC}"
    echo -e "\nNext steps:"
    echo -e "  Run ${BLUE}./scripts/run.sh${NC} to start Real Shell"
}

# Run main function
main "$@"
