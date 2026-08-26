#!/usr/bin/env bash
# synthv-deps.sh - Install DXVK and WebView2 into SynthV Wine prefix
# Part of SVS2-Flakes (https://github.com/SUDOER1337/SVS2-Flakes)
#
# This is the raw script wrapped by the synthv-deps Nix package.
# It can also be used standalone outside of Nix.
#
# Usage:
#   ./synthv-deps.sh [--help|--dxvk|--webview2|--all]
#
# Environment:
#   SYNTHV_PREFIX  - Wine prefix location (default: ~/.local/share/synthv)

set -euo pipefail

SYNTHV_PREFIX="${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
WEBVIEW2_URL="https://go.microsoft.com/fwlink/p/?LinkId=2124703"

# -- Help --
show_help() {
  cat <<'HELP'
synthv-deps - Install DXVK and WebView2 for SynthV

Usage:
  synthv-deps              Install DXVK + WebView2
  synthv-deps --dxvk       Install DXVK only
  synthv-deps --webview2   Install WebView2 only
  synthv-deps --help       Show this help

Environment:
  SYNTHV_PREFIX   Wine prefix location (default: ~/.local/share/synthv)

What this does:
  1. Installs DXVK (Direct3D rendering for SynthV UI)
  2. Sets Windows version to win10 (for WebView2 installation)
  3. Downloads and installs WebView2 (login dialog)
  4. Sets Windows version to win7 (fixes WebView2 rendering in SynthV)
  5. Kills lingering Edge processes

Note: After running, you may need to restart wine processes:
  wineserver -k
HELP
}

# -- Validate prefix exists --
validate_prefix() {
  if [[ ! -f "${SYNTHV_PREFIX}/system.reg" ]]; then
    echo "ERROR: Wine prefix not found at ${SYNTHV_PREFIX}"
    echo "Run synthv-bootstrap first to create the prefix."
    exit 1
  fi
}

# -- Install DXVK --
install_dxvk() {
  echo "Installing DXVK..."
  WINEPREFIX="${SYNTHV_PREFIX}" winetricks dxvk
  echo "DXVK installed successfully."
}

# -- Install WebView2 --
install_webview2() {
  echo "Setting Windows version to win10 (for WebView2 installation)..."
  WINEPREFIX="${SYNTHV_PREFIX}" winetricks win10

  local installer="${SYNTHV_PREFIX}/drive_c/MicrosoftEdgeWebview2Setup.exe"

  if [[ ! -f "${installer}" ]]; then
    echo "Downloading WebView2 bootstrapper..."
    wget -q -O "${installer}" "${WEBVIEW2_URL}"
  else
    echo "WebView2 bootstrapper already downloaded."
  fi

  echo "Installing WebView2..."
  WINEPREFIX="${SYNTHV_PREFIX}" WINEDEBUG=-all wine "${installer}" &
  local bgpid=$!
  sleep 15
  kill "${bgpid}" 2>/dev/null || true
  wait "${bgpid}" 2>/dev/null || true

  echo "Setting Windows version to win7 (fixes WebView2 rendering)..."
  WINEPREFIX="${SYNTHV_PREFIX}" winetricks win7

  echo "Killing lingering Edge processes..."
  WINEPREFIX="${SYNTHV_PREFIX}" wineserver -k 2>/dev/null || true

  echo "WebView2 installed successfully."
}

# -- Check if WebView2 is already installed --
webview2_installed() {
  find "${SYNTHV_PREFIX}" -name "msedgewebview2.exe" -print -quit 2>/dev/null | grep -q .
}

# -- Main --
main() {
  case "${1:-}" in
    --help)
      show_help
      exit 0
      ;;
    --dxvk)
      validate_prefix
      install_dxvk
      exit 0
      ;;
    --webview2)
      validate_prefix
      install_webview2
      exit 0
      ;;
  esac

  validate_prefix

  # Install DXVK (always needed)
  install_dxvk

  # Install WebView2 (only if not already present)
  if webview2_installed; then
    echo "WebView2 already installed, skipping."
  else
    install_webview2
  fi

  echo ""
  echo "Dependencies installed successfully."
  echo "You can now launch SynthV with: synthv2"
}

main "$@"
