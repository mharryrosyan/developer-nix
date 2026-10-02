#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

echo "[i] Pulling latest configurations from Git..."
git pull --rebase

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux*)
    FLAKE_TARGET="developer-linux"
    ;;
  Darwin*)
    if [ "$ARCH" = "arm64" ]; then
      FLAKE_TARGET="developer-darwin-arm"
    else
      FLAKE_TARGET="developer-darwin-x86"
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "[i] Applying configuration for $FLAKE_TARGET..."
if command -v nh &> /dev/null; then
  nh home switch --flake ".#$FLAKE_TARGET"
else
  home-manager switch --flake ".#$FLAKE_TARGET"
fi

echo "[✓] Configuration successfully synchronized!"
