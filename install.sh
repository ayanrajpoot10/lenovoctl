#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Root privileges required. Please use sudo."
    exit 1
fi

echo "Fetching latest version tag from GitHub..."
LATEST_TAG=$(curl -s https://api.github.com/repos/ayanrajpoot10/lenovoctl/tags | grep '"name":' | head -n 1 | cut -d'"' -f4)

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Failed to fetch latest tag."
    exit 1
fi

TAR_URL="https://github.com/ayanrajpoot10/lenovoctl/archive/refs/tags/${LATEST_TAG}.tar.gz"
TMP_DIR=$(mktemp -d)

echo "Downloading $LATEST_TAG..."
if ! curl -sL "$TAR_URL" -o "$TMP_DIR/lenovoctl.tar.gz"; then
    echo "Error: Failed to download archive."
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "Extracting..."
tar -xzf "$TMP_DIR/lenovoctl.tar.gz" -C "$TMP_DIR"

VERSION=${LATEST_TAG#v}
EXTRACTED_DIR="$TMP_DIR/lenovoctl-$VERSION"

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo "Error: Directory extraction failed."
    rm -rf "$TMP_DIR"
    exit 1
fi

BIN_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"

echo "Installing..."

install -m 755 "$EXTRACTED_DIR/lenovoctl" "$BIN_DIR/lenovoctl"
if [ $? -ne 0 ]; then
    echo "Error: Failed to install executable."
    rm -rf "$TMP_DIR"
    exit 1
fi

if [ -f "$EXTRACTED_DIR/lenovoctl.1" ]; then
    mkdir -p "$MAN_DIR"
    install -m 644 "$EXTRACTED_DIR/lenovoctl.1" "$MAN_DIR/lenovoctl.1"
fi

rm -rf "$TMP_DIR"

echo "Done."
