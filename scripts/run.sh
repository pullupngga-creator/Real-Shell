#!/bin/bash
#
# Real Shell Launcher
# Starts Real Shell with proper environment and configuration
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
STATE_DIR="$HOME/.local/state/real-shell"
PID_FILE="$STATE_DIR/runtime/real-shell.pid"

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to check if Real Shell is already running
is_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        else
            # PID file exists but process is dead
            rm -f "$PID_FILE"
            return 1
        fi
    fi
    return 1
}

# Function to start Real Shell
start_shell() {
    print_header "Starting Real Shell"
    
    # Check if already running
    if is_running; then
        echo -e "${YELLOW}⚠${NC} Real Shell is already running (PID: $(cat $PID_FILE))"
        echo -e "Use ${BLUE}./scripts/restart.sh${NC} to restart"
        exit 1
    fi
    
    # Check configuration
    if [ ! -d "$CONFIG_DIR" ]; then
        echo -e "${RED}✗${NC} Configuration directory not found: $CONFIG_DIR"
        echo -e "Run ${BLUE}./scripts/configure.sh${NC} first"
        exit 1
    fi
    
    # Check Quickshell (try both 'qs' and 'quickshell')
    QUICKSHELL_CMD=""
    if command -v qs &> /dev/null; then
        QUICKSHELL_CMD="qs"
    elif command -v quickshell &> /dev/null; then
        QUICKSHELL_CMD="quickshell"
    else
        echo -e "${RED}✗${NC} Quickshell not found"
        echo -e "  Neither 'qs' nor 'quickshell' command found"
        echo -e "Run ${BLUE}./scripts/install.sh${NC} to install dependencies"
        exit 1
    fi
    
    # Check Wayland session
    if [ -z "$WAYLAND_DISPLAY" ]; then
        echo -e "${YELLOW}⚠${NC} Not running in Wayland session"
        echo -e "Real Shell requires Wayland to function properly"
    fi
    
    # Set environment variables
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_LOGGING_RULES="*.debug=false;qt.quick.debug=false"
    
    # Add project directory to QML import path
    export QML2_IMPORT_PATH="$PROJECT_DIR:$PROJECT_DIR/shell:$PROJECT_DIR/components:$PROJECT_DIR/services:$PROJECT_DIR/settings:$PROJECT_DIR/session"
    
    # Create log directory
    mkdir -p "$STATE_DIR/logs/shell"
    
    # Start Quickshell with Real Shell entry point
    echo -e "${GREEN}→${NC} Starting Real Shell..."
    echo -e "  Project: ${BLUE}$PROJECT_DIR${NC}"
    echo -e "  Config:  ${BLUE}$CONFIG_DIR${NC}"
    echo -e "  Entry:   ${BLUE}$PROJECT_DIR/shell.qml${NC}"
    
    # Start in background and save PID
    cd "$PROJECT_DIR"
    $QUICKSHELL_CMD shell.qml > "$STATE_DIR/logs/shell/quickshell.log" 2>&1 &
    local pid=$!
    
    # Save PID
    echo "$pid" > "$PID_FILE"
    
    # Wait a moment to check if it started successfully
    sleep 2
    
    if ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Real Shell started successfully (PID: $pid)"
        echo -e "  Logs: ${BLUE}$STATE_DIR/logs/shell/quickshell.log${NC}"
    else
        echo -e "${RED}✗${NC} Real Shell failed to start"
        echo -e "  Check logs: ${BLUE}$STATE_DIR/logs/shell/quickshell.log${NC}"
        rm -f "$PID_FILE"
        exit 1
    fi
}

# Main routine
main() {
    print_header "Real Shell Launcher"
    
    # Parse arguments
    case "${1:-}" in
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h     Show this help message"
            echo "  --check        Check if Real Shell is running"
            echo "  --foreground   Run in foreground (for debugging)"
            echo ""
            echo "If no options are provided, Real Shell is started in the background."
            exit 0
            ;;
        --check)
            if is_running; then
                echo -e "${GREEN}✓${NC} Real Shell is running (PID: $(cat $PID_FILE))"
                exit 0
            else
                echo -e "${YELLOW}⚠${NC} Real Shell is not running"
                exit 1
            fi
            ;;
        --foreground)
            print_header "Starting Real Shell (Foreground)"
            
            # Check configuration
            if [ ! -d "$CONFIG_DIR" ]; then
                echo -e "${RED}✗${NC} Configuration directory not found: $CONFIG_DIR"
                echo -e "Run ${BLUE}./scripts/configure.sh${NC} first"
                exit 1
            fi
            
            # Check Quickshell (try both 'qs' and 'quickshell')
            QUICKSHELL_CMD=""
            if command -v qs &> /dev/null; then
                QUICKSHELL_CMD="qs"
            elif command -v quickshell &> /dev/null; then
                QUICKSHELL_CMD="quickshell"
            else
                echo -e "${RED}✗${NC} Quickshell not found"
                echo -e "  Neither 'qs' nor 'quickshell' command found"
                echo -e "Run ${BLUE}./scripts/install.sh${NC} to install dependencies"
                exit 1
            fi
            
            # Set environment variables
            export QT_QPA_PLATFORM=wayland
            export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
            export QT_LOGGING_RULES="*.debug=false;qt.quick.debug=false"
            export QML2_IMPORT_PATH="$PROJECT_DIR:$PROJECT_DIR/shell:$PROJECT_DIR/components:$PROJECT_DIR/services:$PROJECT_DIR/settings:$PROJECT_DIR/session"
            
            # Start in foreground
            cd "$PROJECT_DIR"
            $QUICKSHELL_CMD shell.qml
            ;;
        *)
            start_shell
            ;;
    esac
}

# Run main function
main "$@"
