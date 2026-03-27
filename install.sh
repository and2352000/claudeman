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
    echo "⚠️  /usr/local/bin is not writable, installing to $INSTALL_DIR instead."
    echo "    Make sure $INSTALL_DIR is in your PATH."
fi

echo "Installing claudeman to $INSTALL_DIR..."

curl -fsSL "https://raw.githubusercontent.com/$REPO/main/claudeman" \
    -o "$INSTALL_DIR/$BINARY"
chmod +x "$INSTALL_DIR/$BINARY"

echo ""
echo "✅ claudeman installed to $INSTALL_DIR/$BINARY"
echo ""
echo "────────────────────────────────────────────────"
echo "Add the following to your ~/.zshrc or ~/.bashrc:"
echo "────────────────────────────────────────────────"
cat << 'EOF'

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
EOF
echo "────────────────────────────────────────────────"
echo ""
echo "Then reload your shell:"
echo "  source ~/.zshrc"
echo ""
echo "Get started:"
echo "  claudeman init"
