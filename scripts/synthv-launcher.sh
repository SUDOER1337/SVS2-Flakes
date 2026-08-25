#!/usr/bin/env bash
# synthv-launcher.sh - Launch Synthesizer V Studio 2
# Part of SVS2-Flakes (https://codeberg.org/SUDOER1337/SVS2-Flakes)
#
# This is the raw script wrapped by the synthv-launcher Nix package.
# It can also be used standalone outside of Nix.
#
# Usage:
#   ./synthv-launcher.sh [wine-args...]
#
# Environment:
#   SYNTHV_PREFIX  - Wine prefix location (default: ~/.local/share/synthv)
#   WINE           - Wine binary (default: wine)

set -euo pipefail

SYNTHV_PREFIX="${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
WINE="${WINE:-wine}"

show_help() {
  cat <<'HELP'
synthv2 - Launch Synthesizer V Studio 2

Usage:
  synthv2 [options]             Launch SynthV
  synthv2 --help                Show this help

The launcher searches for SynthV in the Wine prefix at:
  ${SYNTHV_PREFIX}

Environment:
  SYNTHV_PREFIX   Wine prefix location (default: ~/.local/share/synthv)

For initial setup:
  1. Run synthv-bootstrap to create the prefix
  2. Place the SynthV installer in ${SYNTHV_PREFIX}/drive_c/
  3. Run: wine installer.exe
HELP
}

main() {
  if [[ "${1:-}" == "--help" ]]; then
    show_help
    exit 0
  fi

  if [[ ! -d "${SYNTHV_PREFIX}" ]]; then
    echo "ERROR: Wine prefix not found at ${SYNTHV_PREFIX}"
    echo "Run 'synthv-bootstrap' first to create it."
    exit 1
  fi

  SYNTHV_EXE=$(find "${SYNTHV_PREFIX}/drive_c" \
    -name "SynthV*.exe" -o \
    -name "synthesizerv*.exe" -o \
    -name "Synthesizer V*.exe" \
    2>/dev/null | head -1 || true)

  if [[ -z "${SYNTHV_EXE}" ]]; then
    echo "ERROR: Synthesizer V executable not found in prefix."
    echo "Install SynthV first using the official installer."
    exit 1
  fi

  export WINEPREFIX="${SYNTHV_PREFIX}"
  export WINEDLLOVERRIDES="winemenubuilder.exe=d"

  exec "${WINE}" "${SYNTHV_EXE}" "$@"
}

main "$@"
