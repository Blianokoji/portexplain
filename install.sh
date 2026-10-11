#!/usr/bin/env bash
# ==============================================================================
# 🔍 portexplain - 1-Command Universal Installer
# Repo: https://github.com/Blianokoji/portexplain
# ==============================================================================

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}==============================================================================${NC}"
echo -e "${GREEN}${BOLD}     🔍 portexplain - Homeserver Network Intelligence & Port Auditor         ${NC}"
echo -e "${BLUE}${BOLD}==============================================================================${NC}"

# Detect Python 3
if ! command -v python3 &>/dev/null; then
    echo -e "${RED}[!] Error: Python 3 is required but not installed.${NC}"
    exit 1
fi

INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/portexplain"
mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If running directly inside repository
if [ -f "${SCRIPT_DIR}/bin/portexplain" ]; then
    echo "Installing from local repository files..."
    cp -f "${SCRIPT_DIR}/bin/portexplain" "${INSTALL_DIR}/portexplain"
    if [ ! -f "${CONFIG_DIR}/services.json" ] && [ -f "${SCRIPT_DIR}/services.json" ]; then
        echo "Seeding initial services registry to ${CONFIG_DIR}/services.json..."
        cp -f "${SCRIPT_DIR}/services.json" "${CONFIG_DIR}/services.json"
    fi
else
    # Remote one-line installation via curl/wget
    echo "Downloading latest portexplain from GitHub..."
    curl -fsSL "https://raw.githubusercontent.com/Blianokoji/portexplain/main/bin/portexplain" -o "${INSTALL_DIR}/portexplain"
    if [ ! -f "${CONFIG_DIR}/services.json" ]; then
        echo "Downloading master services registry..."
        curl -fsSL "https://raw.githubusercontent.com/Blianokoji/portexplain/main/services.json" -o "${CONFIG_DIR}/services.json" || true
    fi
fi

chmod +x "${INSTALL_DIR}/portexplain"

# Verify PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "\n${YELLOW}[!] Notice: ~/.local/bin is not in your current PATH.${NC}"
    echo -e "    Add it to your shell config (~/.bashrc or ~/.zshrc):"
    echo -e "    ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
fi

echo -e "\n${GREEN}✓ Successfully installed portexplain to ${INSTALL_DIR}/portexplain!${NC}"
echo -e "Run ${BOLD}portexplain --help${NC} or ${BOLD}portexplain${NC} to start auditing your network."
