#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Root privileges required. Please use sudo."
    exit 1
fi

BIN_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"

echo "Uninstalling lenovoctl..."

if [ -f "$BIN_DIR/lenovoctl" ]; then
    rm -f "$BIN_DIR/lenovoctl"
fi

if [ -f "$MAN_DIR/lenovoctl.1" ]; then
    rm -f "$MAN_DIR/lenovoctl.1"
    if command -v mandb >/dev/null 2>&1; then
        mandb -q
    fi
fi

echo "Done."
