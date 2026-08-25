{
  lib,
  writeShellScriptBin,
  synthv-env,
}:
# === Packages ===
#   synthv-bootstrap  - Create/manage SynthV Wine prefix
#
# Creates ~/.local/share/synthv, runs wineboot, validates prefix health.
# Use --destroy to nuke (with confirmation).

writeShellScriptBin "synthv-bootstrap" ''
  set -euo pipefail

  # -- Configuration --
  SYNTHV_PREFIX="''${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
  SYNTHV_ENV="${synthv-env}/bin"

  # -- Help --
  show_help() {
    cat <<'HELP'
synthv-bootstrap - Initialize SynthV Wine prefix

Usage:
  synthv-bootstrap              Create/validate prefix
  synthv-bootstrap --help       Show this help
  synthv-bootstrap --destroy    Remove prefix (requires confirmation)

Environment:
  SYNTHV_PREFIX   Wine prefix location (default: ~/.local/share/synthv)
HELP
  }

  # -- Arg parse --
  case "''${1:-}" in
    --help)
      show_help
      exit 0
      ;;
    --destroy)
      echo "WARNING: This will remove ''${SYNTHV_PREFIX}"
      echo "Are you sure? Type 'yes' to confirm: "
      read -r confirmation
      if [[ "''${confirmation}" == "yes" ]]; then
        rm -rf "''${SYNTHV_PREFIX}"
        echo "Removed ''${SYNTHV_PREFIX}"
      else
        echo "Aborted."
      fi
      exit 0
      ;;
  esac

  # -- Create prefix --
  if [[ ! -d "''${SYNTHV_PREFIX}" ]]; then
    echo "Creating Wine prefix at ''${SYNTHV_PREFIX} ..."
    export WINEPREFIX="''${SYNTHV_PREFIX}"
    export PATH="''${SYNTHV_ENV}:$PATH"
    export WINEARCH="win64"

    wineboot -u
    echo "Prefix created successfully."
  else
    echo "Prefix already exists at ''${SYNTHV_PREFIX}"
  fi

  # -- Validate prefix --
  if [[ ! -f "''${SYNTHV_PREFIX}/system.reg" ]]; then
    echo "ERROR: Prefix appears corrupted (missing system.reg)"
    exit 1
  fi
  echo "Prefix is healthy."
''
