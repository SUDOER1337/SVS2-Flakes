{
  lib,
  writeShellScriptBin,
  synthv-env,
}:
# === Packages ===
#   synthv-launcher  - Launch Synthesizer V Studio 2 in managed prefix
#
# Searches the managed prefix for a SynthV executable and launches it via Wine.

writeShellScriptBin "synthv2" ''
  set -euo pipefail

  # -- Configuration --
  SYNTHV_PREFIX="''${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
  SYNTHV_ENV="${synthv-env}/bin"

  # -- Help --
  if [[ "''${1:-}" == "--help" ]]; then
    cat <<'HELP'
synthv2 - Launch Synthesizer V Studio 2

Usage:
  synthv2 [options]             Launch SynthV
  synthv2 --help                Show this help

The launcher searches for SynthV in the Wine prefix at:
  ''${SYNTHV_PREFIX}

Environment:
  SYNTHV_PREFIX   Wine prefix location (default: ~/.local/share/synthv)

For initial setup:
  1. Run synthv-bootstrap to create the prefix
  2. Place the SynthV installer in ''${SYNTHV_PREFIX}/drive_c/
  3. Run: wine svstudio2-core-setup-latest.exe
HELP
    exit 0
  fi

  # -- Validate prefix --
  if [[ ! -d "''${SYNTHV_PREFIX}" ]]; then
    echo "ERROR: Wine prefix not found at ''${SYNTHV_PREFIX}"
    echo "Run 'synthv-bootstrap' first to create it."
    exit 1
  fi

  # -- Find SynthV executable --
  SYNTHV_EXE=$(find "''${SYNTHV_PREFIX}/drive_c" \
    -name "SynthV*.exe" -o \
    -name "synthesizerv*.exe" -o \
    -name "Synthesizer V*.exe" \
    2>/dev/null | head -1 || true)

  if [[ -z "''${SYNTHV_EXE}" ]]; then
    echo "ERROR: Synthesizer V executable not found in prefix."
    echo "Install SynthV first using the official installer."
    exit 1
  fi

  # -- Launch --
  export WINEPREFIX="''${SYNTHV_PREFIX}"
  export PATH="''${SYNTHV_ENV}:$PATH"
  # Suppress Wine desktop integration dialogs
  export WINEDLLOVERRIDES="winemenubuilder.exe=d"

  exec wine "''${SYNTHV_EXE}" "$@"
''
