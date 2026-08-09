#!/bin/bash
#
# Real Shell Configuration Script
# Creates and configures runtime directories and configuration files
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

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to create directory
create_directory() {
    local name=$1
    local path=$2
    
    if [ -d "$path" ]; then
        echo -e "${GREEN}✓${NC} $name exists ($path)"
    else
        mkdir -p "$path"
        echo -e "${GREEN}✓${NC} $name created ($path)"
    fi
}

# Function to create symlink
create_symlink() {
    local name=$1
    local source=$2
    local target=$3
    
    if [ -L "$target" ]; then
        echo -e "${GREEN}✓${NC} $name symlink exists ($target)"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}⚠${NC} $name target exists but is not a symlink ($target)"
    else
        ln -s "$source" "$target"
        echo -e "${GREEN}✓${NC} $name symlink created ($target → $source)"
    fi
}

# Function to write config file
write_config() {
    local file=$1
    local content=$2
    
    if [ -f "$file" ]; then
        echo -e "${YELLOW}⚠${NC} Config file exists: $file (skipping)"
    else
        echo "$content" > "$file"
        echo -e "${GREEN}✓${NC} Config file created: $file"
    fi
}

# Main configuration routine
main() {
    print_header "Real Shell Configuration"
    
    # Create XDG directories
    print_header "Creating XDG Directories"
    
    create_directory "Config directory" "$CONFIG_DIR"
    create_directory "Data directory" "$DATA_DIR"
    create_directory "State directory" "$STATE_DIR"
    create_directory "Cache directory" "$CACHE_DIR"
    
    # Create subdirectories
    print_header "Creating Subdirectories"
    
    create_directory "Settings" "$CONFIG_DIR/settings"
    create_directory "Themes" "$CONFIG_DIR/themes"
    create_directory "Wallpapers" "$CONFIG_DIR/wallpapers"
    create_directory "Logs" "$STATE_DIR/logs"
    create_directory "Runtime" "$STATE_DIR/runtime"
    create_directory "Cache" "$CACHE_DIR/icons"
    create_directory "Cache" "$CACHE_DIR/thumbnails"
    
    # Create default settings
    print_header "Creating Default Settings"
    
    local settings_content='{
  "version": "1.0.0",
  "theme": {
    "mode": "dynamic",
    "accent": "blue",
    "darkMode": true
  },
  "panel": {
    "position": "top",
    "height": 48,
    "autoHide": false
  },
  "launcher": {
    "searchEnabled": true,
    "recentApps": true,
    "categories": true
  },
  "notifications": {
    "enabled": true,
    "position": "top-right",
    "doNotDisturb": false
  },
  "audio": {
    "defaultOutput": null,
    "defaultInput": null,
    "volume": 0.5
  },
  "network": {
    "autoConnect": true,
    "notifyOnConnect": true
  },
  "bluetooth": {
    "autoConnect": true,
    "notifyOnConnect": true
  },
  "power": {
    "powerProfile": "balanced",
    "batteryWarning": 20,
    "batteryCritical": 10
  }
}'
    
    write_config "$CONFIG_DIR/settings/settings.json" "$settings_content"
    
    # Create Quickshell configuration
    print_header "Creating Quickshell Configuration"
    
    # Note: Quickshell now uses direct shell.qml entry point, not config.json
    # This section is kept for future Quickshell config support if needed
    echo -e "${YELLOW}⚠${NC} Quickshell now uses direct shell.qml entry point"
    echo -e "  Config file creation skipped (not required for current setup)"
    
    # Create Hyprland integration
    print_header "Creating Hyprland Integration"
    
    local hyprland_config="# Real Shell Hyprland Integration
# This file is sourced by Hyprland to start Real Shell

# Start Real Shell on session startup
exec-once = $PROJECT_DIR/scripts/run.sh"
    
    write_config "$CONFIG_DIR/hyprland.conf" "$hyprland_config"
    
    # Create log directory structure
    print_header "Creating Log Structure"
    
    create_directory "Shell logs" "$STATE_DIR/logs/shell"
    create_directory "Service logs" "$STATE_DIR/logs/services"
    create_directory "Backend logs" "$STATE_DIR/logs/backends"
    
    # Create runtime state
    print_header "Creating Runtime State"
    
    local runtime_state='{
  "sessionId": null,
  "startTime": null,
  "lastActivity": null,
  "services": {},
  "backends": {}
}'
    
    write_config "$STATE_DIR/runtime/state.json" "$runtime_state"
    
    # Set permissions
    print_header "Setting Permissions"
    
    chmod 755 "$CONFIG_DIR"
    chmod 755 "$DATA_DIR"
    chmod 755 "$STATE_DIR"
    chmod 755 "$CACHE_DIR"
    
    chmod 700 "$CONFIG_DIR/settings"
    chmod 755 "$STATE_DIR/logs"
    chmod 755 "$STATE_DIR/runtime"
    chmod 755 "$CACHE_DIR/icons"
    chmod 755 "$CACHE_DIR/thumbnails"
    
    # Make scripts executable
    print_header "Making Scripts Executable"
    
    chmod +x "$SCRIPT_DIR/check.sh"
    chmod +x "$SCRIPT_DIR/install.sh"
    chmod +x "$SCRIPT_DIR/configure.sh"
    chmod +x "$SCRIPT_DIR/run.sh"
    chmod +x "$SCRIPT_DIR/stop.sh"
    chmod +x "$SCRIPT_DIR/restart.sh"
    chmod +x "$SCRIPT_DIR/doctor.sh"
    chmod +x "$SCRIPT_DIR/reset.sh"
    chmod +x "$SCRIPT_DIR/uninstall.sh"
    chmod +x "$SCRIPT_DIR/setup.sh"
    
    echo -e "${GREEN}✓${NC} All scripts made executable"
    
    # Summary
    print_header "Configuration Complete"
    
    echo -e "${GREEN}Real Shell configured successfully.${NC}"
    echo -e "\nConfiguration locations:"
    echo -e "  Config: ${BLUE}$CONFIG_DIR${NC}"
    echo -e "  Data:   ${BLUE}$DATA_DIR${NC}"
    echo -e "  State:  ${BLUE}$STATE_DIR${NC}"
    echo -e "  Cache:  ${BLUE}$CACHE_DIR${NC}"
    echo -e "\nNext steps:"
    echo -e "  1. Add ${BLUE}source ~/.config/real-shell/hyprland.conf${NC} to your Hyprland config"
    echo -e "  2. Run ${BLUE}./scripts/run.sh${NC} to start Real Shell"
}

# Run main function
main "$@"
