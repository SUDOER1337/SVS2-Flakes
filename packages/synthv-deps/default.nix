{
  lib,
  writeShellScriptBin,
  synthv-env,
  wget,
  gnugrep,
  coreutils,
}:
# === Packages ===
#   synthv-deps  - Install DXVK and WebView2 for SynthV
#
# Installs DXVK (Direct3D rendering) and WebView2 (login dialog)
# into the SynthV Wine prefix.

writeShellScriptBin "synthv-deps" ''
  set -euo pipefail

  # -- Configuration --
  SYNTHV_PREFIX="''${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
  SYNTHV_ENV="${synthv-env}/bin"
  WEBVIEW2_URL="https://go.microsoft.com/fwlink/p/?LinkId=2124703"

  # -- Tools --
  WGET="${wget}/bin/wget"
  GREP="${gnugrep}/bin/grep"
  FIND="${coreutils}/bin/find"

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
    if [[ ! -f "''${SYNTHV_PREFIX}/system.reg" ]]; then
      echo "ERROR: Wine prefix not found at ''${SYNTHV_PREFIX}"
      echo "Run synthv-bootstrap first to create the prefix."
      exit 1
    fi
  }

  # -- Install DXVK --
  install_dxvk() {
    echo "Installing DXVK..."
    WINEPREFIX="''${SYNTHV_PREFIX}" PATH="''${SYNTHV_ENV}:$PATH" winetricks dxvk
    echo "DXVK installed successfully."
  }

  # -- Install WebView2 --
  install_webview2() {
    echo "Setting Windows version to win10 (for WebView2 installation)..."
    WINEPREFIX="''${SYNTHV_PREFIX}" PATH="''${SYNTHV_ENV}:$PATH" winetricks win10

    local installer="''${SYNTHV_PREFIX}/drive_c/MicrosoftEdgeWebview2Setup.exe"

    if [[ ! -f "''${installer}" ]]; then
      echo "Downloading WebView2 bootstrapper..."
      "''${WGET}" -q -O "''${installer}" "''${WEBVIEW2_URL}"
    else
      echo "WebView2 bootstrapper already downloaded."
    fi

    echo "Installing WebView2..."
    WINEPREFIX="''${SYNTHV_PREFIX}" WINEDEBUG=-all PATH="''${SYNTHV_ENV}:$PATH" wine "''${installer}" &
    local bgpid=$!
    sleep 15
    kill "''${bgpid}" 2>/dev/null || true
    wait "''${bgpid}" 2>/dev/null || true

    echo "Setting Windows version to win7 (fixes WebView2 rendering)..."
    WINEPREFIX="''${SYNTHV_PREFIX}" PATH="''${SYNTHV_ENV}:$PATH" winetricks win7

    echo "Killing lingering Edge processes..."
    WINEPREFIX="''${SYNTHV_PREFIX}" PATH="''${SYNTHV_ENV}:$PATH" wineserver -k 2>/dev/null || true

    echo "WebView2 installed successfully."
  }

  # -- Check if WebView2 is already installed --
  webview2_installed() {
    "''${FIND}" "''${SYNTHV_PREFIX}" -name "msedgewebview2.exe" -print 2>/dev/null | "''${GREP}" -q .
  }

  # -- Main --
  main() {
    case "''${1:-}" in
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
''
