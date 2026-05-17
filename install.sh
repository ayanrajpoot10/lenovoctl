#!/bin/bash

REPO="ayanrajpoot10/lenovoctl"
TAGS_API_URL="https://api.github.com/repos/${REPO}/tags"
ARCHIVE_BASE_URL="https://github.com/${REPO}/archive/refs/tags"
BIN_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"

if [ "$EUID" -ne 0 ]; then
    echo "Root privileges required. Please use sudo."
    exit 1
fi

LATEST_TAG=$(curl -s "$TAGS_API_URL" | grep '"name":' | head -n 1 | cut -d'"' -f4)

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Failed to fetch latest tag."
    exit 1
fi

VERSION=${LATEST_TAG#v}
echo "Latest version: $VERSION"

TAR_URL="${ARCHIVE_BASE_URL}/${LATEST_TAG}.tar.gz"
TMP_DIR=$(mktemp -d)

if ! curl -sL "$TAR_URL" -o "$TMP_DIR/lenovoctl.tar.gz"; then
    echo "Error: Failed to download archive."
    rm -rf "$TMP_DIR"
    exit 1
fi

tar -xzf "$TMP_DIR/lenovoctl.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/lenovoctl-$VERSION"

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo "Error: Directory extraction failed."
    rm -rf "$TMP_DIR"
    exit 1
fi

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
