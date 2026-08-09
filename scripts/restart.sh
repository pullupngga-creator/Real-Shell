#!/bin/bash
#
# Real Shell Restart Script
# Restarts a running Real Shell instance
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

# Main routine
main() {
    print_header "Real Shell Restart"
    
    # Stop if running
    if "$SCRIPT_DIR/stop.sh"; then
        echo -e "${GREEN}✓${NC} Real Shell stopped"
    else
        echo -e "${YELLOW}⚠${NC} Real Shell was not running"
    fi
    
    # Wait a moment for cleanup
    sleep 1
    
    # Start again
    if "$SCRIPT_DIR/run.sh"; then
        echo -e "${GREEN}✓${NC} Real Shell restarted successfully"
    else
        echo -e "${RED}✗${NC} Failed to restart Real Shell"
        exit 1
    fi
}

# Run main function
main "$@"
