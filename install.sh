#!/bin/bash
set -e

REPO="huangqianrui/claudeman"
INSTALL_DIR="/usr/local/bin"
BINARY="claudeman"

# Check for jq dependency
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq is required but not installed."
    if command -v brew &> /dev/null; then
        echo "Installing jq via Homebrew..."
        brew install jq
    else
        echo "Please install jq first: https://stedolan.github.io/jq/download/"
        exit 1
    fi
fi

# Determine install dir (fallback to ~/.local/bin if no sudo)
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo "Installing claudeman to $INSTALL_DIR..."

curl -fsSL "https://raw.githubusercontent.com/$REPO/main/claudeman" \
    -o "$INSTALL_DIR/$BINARY"
chmod +x "$INSTALL_DIR/$BINARY"

# Check if install dir is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo ""
    echo "⚠️  $INSTALL_DIR is not in your PATH."
    echo "Add the following to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
fi

echo "✅ claudeman installed successfully!"
echo ""
echo "Get started:"
echo "  claudeman init"
echo ""
echo "For profile switching, add this to your ~/.zshrc or ~/.bashrc:"
echo "  function claude() { eval \"\$(claudeman env)\"; command claude \"\$@\"; }"
