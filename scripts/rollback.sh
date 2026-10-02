#!/usr/bin/env bash
set -euo pipefail

echo "[i] Rolling back to the previous generation..."
home-manager switch --rollback
echo "[✓] Successfully rolled back!"
