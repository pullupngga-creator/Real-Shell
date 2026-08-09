#!/bin/bash
#
# Real Shell Setup Script
# Orchestrates the complete Real Shell installation and configuration process
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

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to print step
print_step() {
    local step=$1
    local total=$2
    local message=$3
    echo -e "\n${BLUE}[$step/$total]${NC} $message"
}

# Main setup routine
main() {
    print_header "       REAL SHELL SETUP"
    
    local total_steps=6
    local current_step=0
    
    # Step 1: Check system
    ((current_step++))
    print_step $current_step $total_steps "Checking system"
    
    if "$SCRIPT_DIR/check.sh"; then
        echo -e "${GREEN}✓${NC} System check passed"
    else
        echo -e "${YELLOW}⚠${NC} System check found issues"
        echo -e "  Run ${BLUE}./scripts/check.sh${NC} for details"
        echo -e "  Continuing with installation..."
    fi
    
    # Step 2: Install dependencies
    ((current_step++))
    print_step $current_step $total_steps "Installing dependencies"
    
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}⚠${NC} Not running as root"
        echo -e "  Skipping package installation"
        echo -e "  Run ${BLUE}sudo ./scripts/install.sh${NC} to install dependencies"
    else
        if "$SCRIPT_DIR/install.sh"; then
            echo -e "${GREEN}✓${NC} Dependencies installed"
        else
            echo -e "${RED}✗${NC} Dependency installation failed"
            exit 1
        fi
    fi
    
    # Step 3: Prepare directories
    ((current_step++))
    print_step $current_step $total_steps "Preparing directories"
    
    if "$SCRIPT_DIR/configure.sh"; then
        echo -e "${GREEN}✓${NC} Directories prepared"
    else
        echo -e "${RED}✗${NC} Directory preparation failed"
        exit 1
    fi
    
    # Step 4: Configure Real Shell
    ((current_step++))
    print_step $current_step $total_steps "Configuring Real Shell"
    
    # This is handled by configure.sh, but we can add additional steps here
    echo -e "${GREEN}✓${NC} Real Shell configured"
    
    # Step 5: Configure Hyprland integration
    ((current_step++))
    print_step $current_step $total_steps "Configuring Hyprland integration"
    
    local hyprland_config="$HOME/.config/hypr/hyprland.conf"
    local real_shell_config="$HOME/.config/real-shell/hyprland.conf"
    
    if [ -f "$hyprland_config" ]; then
        if grep -q "real-shell" "$hyprland_config"; then
            echo -e "${GREEN}✓${NC} Hyprland integration already configured"
        else
            echo -e "${YELLOW}→${NC} Adding Real Shell integration to Hyprland config"
            echo "" >> "$hyprland_config"
            echo "# Real Shell integration" >> "$hyprland_config"
            echo "source = ~/.config/real-shell/hyprland.conf" >> "$hyprland_config"
            echo -e "${GREEN}✓${NC} Hyprland integration added"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Hyprland config not found"
        echo -e "  Manual integration required"
        echo -e "  Add to ${BLUE}~/.config/hypr/hyprland.conf${NC}:"
        echo -e "  source = ~/.config/real-shell/hyprland.conf"
    fi
    
    # Step 6: Validation
    ((current_step++))
    print_step $current_step $total_steps "Validation"
    
    if "$SCRIPT_DIR/doctor.sh"; then
        echo -e "${GREEN}✓${NC} Validation passed"
    else
        echo -e "${YELLOW}⚠${NC} Validation found warnings"
        echo -e "  Run ${BLUE}./scripts/doctor.sh${NC} for details"
    fi
    
    # Summary
    print_header " Real Shell is ready."
    
    echo -e "\nRun:"
    echo -e "  ${BLUE}./scripts/run.sh${NC}"
    echo -e ""
    echo -e "Or for automatic startup on Hyprland launch:"
    echo -e "  Restart your Hyprland session"
    echo -e ""
    echo -e "Useful commands:"
    echo -e "  ${BLUE}./scripts/doctor.sh${NC}   - Check system status"
    echo -e "  ${BLUE}./scripts/stop.sh${NC}     - Stop Real Shell"
    echo -e "  ${BLUE}./scripts/restart.sh${NC}  - Restart Real Shell"
    echo -e "  ${BLUE}./scripts/reset.sh${NC}    - Reset Real Shell state"
}

# Run main function
main "$@"
