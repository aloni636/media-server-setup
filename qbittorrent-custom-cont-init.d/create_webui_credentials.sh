#!/bin/sh
set -e

SECRETS_BASE="/run/secrets"
CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"

USER=$(cat "$SECRETS_BASE/qbittorrent_username")
PASS=$(cat "$SECRETS_BASE/qbittorrent_password")
HASH=$(printf '%s:%s' "$USER" "$PASS" | md5sum | awk '{print $1}')

mkdir -p "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"

# Remove existing WebUI credentials if any
grep -v -E '^WebUI\\Username=|^WebUI\\Password_ha1=' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" || true

echo "WebUI\\Username=$USER" >> "$CONFIG_FILE.tmp"
echo "WebUI\\Password_ha1=@ByteArray($HASH)" >> "$CONFIG_FILE.tmp"

mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

echo "[custom-init] WebUI credentials set for qBittorrent."
