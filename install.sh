#!/bin/bash
set -e

REPO="huangqianrui/claudeman"
INSTALL_DIR="/usr/local/bin"
BINARY="claudeman"

SHELL_SNIPPET='
# claudeman - Claude Code profile manager
refresh-claude() { eval "$(command claudeman env)"; }

claudeman() {
    if [ "$1" = "sw" ]; then
        eval "$(command claudeman sw "${@:2}")"
    else
        command claudeman "$@"
    fi
}

refresh-claude
'

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
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$RC_FILE"
fi

# Detect shell rc file
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
else
    RC_FILE="$HOME/.bashrc"
fi

# Add shell snippet if not already present
if grep -q "claudeman env" "$RC_FILE" 2>/dev/null; then
    echo "✅ Shell config already set up in $RC_FILE"
else
    echo "$SHELL_SNIPPET" >> "$RC_FILE"
    echo "✅ Shell config added to $RC_FILE"
fi

echo ""
echo "✅ claudeman installed successfully!"
echo ""
echo "Reload your shell or run:"
echo "  source $RC_FILE"
echo ""
echo "Then get started:"
echo "  claudeman init"
