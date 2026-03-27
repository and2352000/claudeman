#!/bin/bash
set -e

REPO="and2352000/claudeman"
INSTALL_DIR="/usr/local/bin"
BINARY="claudeman"

# Check for jq dependency
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq is required but not installed. Run: brew install jq"
    exit 1
fi

# Determine install dir (fallback to ~/.local/bin if no sudo)
if [ ! -w "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo "claudeman will be installed to: $INSTALL_DIR/$BINARY"
echo ""
read -p "Continue? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi
echo ""
echo "Installing..."

curl -fsSL "https://raw.githubusercontent.com/$REPO/main/claudeman" \
    -o "$INSTALL_DIR/$BINARY"
chmod +x "$INSTALL_DIR/$BINARY"

echo ""
echo "✅ claudeman installed to $INSTALL_DIR/$BINARY"

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "⚠️  $INSTALL_DIR is not in your PATH. Add this to your ~/.zshrc or ~/.bashrc:"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
fi
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
