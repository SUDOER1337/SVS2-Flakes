#!/usr/bin/env bash
# synthv-bootstrap.sh - Create/manage SynthV Wine prefix
# Part of SVS2-Flakes (https://codeberg.org/SUDOER1337/SVS2-Flakes)
#
# This is the raw script wrapped by the synthv-bootstrap Nix package.
# It can also be used standalone outside of Nix.
#
# Usage:
#   ./synthv-bootstrap.sh [--help|--destroy]
#
# Environment:
#   SYNTHV_PREFIX  - Wine prefix location (default: ~/.local/share/synthv)
#   WINE           - Wine binary (default: wine)
#   WINEARCH       - Architecture (default: win64)

set -euo pipefail

SYNTHV_PREFIX="${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
WINE="${WINE:-wine}"
WINEARCH="${WINEARCH:-win64}"

show_help() {
  cat <<'HELP'
synthv-bootstrap - Initialize SynthV Wine prefix

Usage:
  synthv-bootstrap              Create/validate prefix
  synthv-bootstrap --help       Show this help
  synthv-bootstrap --destroy    Remove prefix (requires confirmation)

Environment:
  SYNTHV_PREFIX   Wine prefix location (default: ~/.local/share/synthv)
  WINE            Wine binary (default: wine)
  WINEARCH        Architecture (default: win64)
HELP
}

main() {
  case "${1:-}" in
    --help)
      show_help
      exit 0
      ;;
    --destroy)
      echo "WARNING: This will remove ${SYNTHV_PREFIX}"
      echo "Are you sure? Type 'yes' to confirm: "
      read -r confirmation
      if [[ "${confirmation}" == "yes" ]]; then
        rm -rf "${SYNTHV_PREFIX}"
        echo "Removed ${SYNTHV_PREFIX}"
      else
        echo "Aborted."
      fi
      exit 0
      ;;
  esac

  if [[ ! -d "${SYNTHV_PREFIX}" ]]; then
    echo "Creating Wine prefix at ${SYNTHV_PREFIX}..."
    export WINEPREFIX="${SYNTHV_PREFIX}"
    export WINEARCH="${WINEARCH}"
    wineboot -u
    echo "Prefix created successfully."
  else
    echo "Prefix already exists at ${SYNTHV_PREFIX}"
  fi

  if [[ ! -f "${SYNTHV_PREFIX}/system.reg" ]]; then
    echo "ERROR: Prefix appears corrupted (missing system.reg)"
    exit 1
  fi

  echo "Prefix is healthy."
}

main "$@"
