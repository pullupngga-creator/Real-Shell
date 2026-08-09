#!/bin/bash
#
# Real Shell Stop Script
# Stops a running Real Shell instance
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# XDG directories
STATE_DIR="$HOME/.local/state/real-shell"
PID_FILE="$STATE_DIR/runtime/real-shell.pid"

# Function to print section header
print_header() {
    echo -e "\n${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

# Function to check if Real Shell is running
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

# Function to stop Real Shell
stop_shell() {
    print_header "Stopping Real Shell"
    
    # Check if running
    if ! is_running; then
        echo -e "${YELLOW}⚠${NC} Real Shell is not running"
        exit 0
    fi
    
    local pid=$(cat "$PID_FILE")
    echo -e "${GREEN}→${NC} Stopping Real Shell (PID: $pid)..."
    
    # Send SIGTERM first
    kill "$pid" 2>/dev/null || true
    
    # Wait for graceful shutdown
    local count=0
    while ps -p "$pid" > /dev/null 2>&1 && [ $count -lt 10 ]; do
        sleep 1
        ((count++))
    done
    
    # If still running, force kill
    if ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${YELLOW}→${NC} Force killing Real Shell..."
        kill -9 "$pid" 2>/dev/null || true
        sleep 1
    fi
    
    # Verify it's stopped
    if ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${RED}✗${NC} Failed to stop Real Shell"
        exit 1
    else
        echo -e "${GREEN}✓${NC} Real Shell stopped successfully"
        rm -f "$PID_FILE"
    fi
}

# Main routine
main() {
    print_header "Real Shell Stop"
    
    # Parse arguments
    case "${1:-}" in
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h     Show this help message"
            echo "  --force        Force kill without graceful shutdown"
            echo ""
            exit 0
            ;;
        --force)
            print_header "Force Stopping Real Shell"
            
            if ! is_running; then
                echo -e "${YELLOW}⚠${NC} Real Shell is not running"
                exit 0
            fi
            
            local pid=$(cat "$PID_FILE")
            echo -e "${YELLOW}→${NC} Force killing Real Shell (PID: $pid)..."
            kill -9 "$pid" 2>/dev/null || true
            rm -f "$PID_FILE"
            echo -e "${GREEN}✓${NC} Real Shell force stopped"
            ;;
        *)
            stop_shell
            ;;
    esac
}

# Run main function
main "$@"
