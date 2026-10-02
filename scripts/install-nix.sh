#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo "  Standardized Developer Platform Onboarding (Nix)"
echo "=========================================================="

# 1. Detect Architecture & OS
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

echo "[✓] Detected Target: $FLAKE_TARGET ($OS / $ARCH)"

# 2. Check if Nix is installed
if ! command -v nix &> /dev/null; then
  echo "[i] Installing Determinate Nix with Flakes enabled..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  echo "[i] Sourcing Nix environment..."
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
fi

# 3. Apply Home Manager Flake
echo "[i] Building and switching to $FLAKE_TARGET..."
nix run home-manager/master -- switch --flake ".#$FLAKE_TARGET"

echo ""
echo "=========================================================="
echo "  [✓] Setup Complete!"
echo "  - Please fill in your secrets in ~/.config/company-ai/secrets.env"
echo "  - Use 'dev-sync' to pull and apply future team updates"
echo "  - Use 'dev-rollback' to instantly revert if something breaks"
echo "=========================================================="
