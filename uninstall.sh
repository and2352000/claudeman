#!/bin/bash
set -e

BINARY="claudeman"
CONFIG_DIR="$HOME/.claudeman"

# Find where claudeman is installed
INSTALL_PATH=$(command -v "$BINARY" 2>/dev/null || true)

if [ -z "$INSTALL_PATH" ]; then
    echo "claudeman is not installed (not found in PATH)."
else
    rm -f "$INSTALL_PATH"
    echo "✅ Removed $INSTALL_PATH"
fi

if [ -d "$CONFIG_DIR" ]; then
    echo ""
    echo "Config directory found: $CONFIG_DIR"
    echo "To remove all profiles and config, run:"
    echo "  rm -rf $CONFIG_DIR"
else
    echo "No config directory found."
fi

echo ""
echo "────────────────────────────────────────────────"
echo "Remember to remove the claudeman snippet from"
echo "your ~/.zshrc or ~/.bashrc (the block between"
echo "\"# claudeman\" and \"refresh-claude\")."
echo "────────────────────────────────────────────────"
echo ""
echo "✅ claudeman uninstalled."
