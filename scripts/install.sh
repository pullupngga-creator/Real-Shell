#!/bin/bash
#
# Real Shell Dependency Installer
# Installs required dependencies for Real Shell on Arch Linux
# This script must run as normal user, uses sudo for system operations
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Refuse to run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}ERROR: Do not run Real Shell installer as root.${NC}"
    echo
    echo "This installer must run as a normal user."
    echo "It will use sudo for system operations automatically."
    echo
    exit 1
fi

# Check for sudo availability
if ! command -v sudo >/dev/null 2>&1; then
    echo -e "${RED}ERROR: sudo is required for system package installation.${NC}"
    exit 1
fi

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to check if package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null
    return $?
}

# Function to install package
install_package() {
    local name=$1
    local package=$2
    
    if is_installed "$package"; then
        echo -e "${GREEN}✓${NC} $name already installed"
        return 0
    else
        echo -e "${YELLOW}→${NC} Installing $name..."
        sudo pacman -S --noconfirm --needed "$package"
        echo -e "${GREEN}✓${NC} $name installed"
        return 0
    fi
}

# Function to install AUR package
install_aur() {
    local name=$1
    local package=$2
    
    if is_installed "$package"; then
        echo -e "${GREEN}✓${NC} $name already installed"
        return 0
    else
        echo -e "${YELLOW}→${NC} Installing $name from AUR..."
        
        # Check if yay is installed
        if ! command -v yay &> /dev/null; then
            echo -e "${YELLOW}→${NC} Installing yay for AUR support..."
            sudo pacman -S --noconfirm --needed base-devel git
            
            local build_dir
            build_dir="$(mktemp -d)"
            
            git clone https://aur.archlinux.org/yay.git "$build_dir/yay"
            cd "$build_dir/yay"
            makepkg -si --noconfirm
            cd -
            rm -rf "$build_dir"
        fi
        
        yay -S --noconfirm --needed "$package"
        echo -e "${GREEN}✓${NC} $name installed"
        return 0
    fi
}

# Main installation routine
main() {
    print_header "Real Shell Dependency Installer"
    
    # Update package databases
    print_header "Updating Package Databases"
    sudo pacman -Sy
    
    # Core System Dependencies
    print_header "Core System Dependencies"
    
    install_package "Qt6" "qt6-base"
    install_package "Qt6 Declarative" "qt6-declarative"
    install_package "Qt6 Wayland" "qt6-wayland"
    install_package "Wayland" "wayland"
    install_package "Wayland Protocols" "wayland-protocols"
    
    # Audio Dependencies
    print_header "Audio Dependencies"
    
    install_package "PipeWire" "pipewire"
    install_package "PipeWire Pulse" "pipewire-pulse"
    install_package "PipeWire ALSA" "pipewire-alsa"
    install_package "PipeWire JACK" "pipewire-jack"
    install_package "WirePlumber" "wireplumber"
    
    # Network Dependencies
    print_header "Network Dependencies"
    
    install_package "NetworkManager" "networkmanager"
    
    # Bluetooth Dependencies
    print_header "Bluetooth Dependencies"
    
    install_package "BlueZ" "bluez"
    install_package "BlueZ Utils" "bluez-utils"
    
    # System Dependencies
    print_header "System Dependencies"
    
    install_package "systemd" "systemd"
    install_package "D-Bus" "dbus"
    
    # Utility Dependencies
    print_header "Utility Dependencies"
    
    install_package "brightnessctl" "brightnessctl"
    install_package "pamixer" "pamixer"
    install_package "playerctl" "playerctl"
    install_package "jq" "jq"
    install_package "curl" "curl"
    install_package "wget" "wget"
    
    # Quickshell (AUR)
    print_header "Quickshell"
    
    install_aur "Quickshell" "quickshell"
    
    # Development Tools (optional)
    print_header "Development Tools (Optional)"
    
    install_package "git" "git"
    install_package "npm" "npm"
    install_package "Node.js" "nodejs"
    
    # Enable services
    print_header "Enabling System Services"
    
    echo -e "${YELLOW}→${NC} Enabling NetworkManager..."
    sudo systemctl enable NetworkManager.service
    
    echo -e "${YELLOW}→${NC} Enabling PipeWire..."
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    
    echo -e "${YELLOW}→${NC} Enabling Bluetooth..."
    sudo systemctl enable bluetooth.service
    
    # Start services
    print_header "Starting System Services"
    
    echo -e "${YELLOW}→${NC} Starting NetworkManager..."
    sudo systemctl start NetworkManager.service
    
    echo -e "${YELLOW}→${NC} Starting Bluetooth..."
    sudo systemctl start bluetooth.service
    
    # Summary
    print_header "Installation Complete"
    
    echo -e "${GREEN}All dependencies installed successfully.${NC}"
    echo -e "\nNext steps:"
    echo -e "  1. Run ${BLUE}./scripts/configure.sh${NC} to configure Real Shell"
    echo -e "  2. Run ${BLUE}./scripts/run.sh${NC} to start Real Shell"
}

# Run main function
main "$@"
