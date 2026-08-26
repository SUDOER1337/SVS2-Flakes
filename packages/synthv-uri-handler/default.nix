{
  lib,
  writeShellScriptBin,
  synthv-env,
  coreutils,
  xdg-utils,
}:
# === Packages ===
#   synthv-uri-handler  - Register dreamtonics-svstudio2:// URI scheme
#
# Registers a MIME handler so that browser OAuth callbacks for SynthV
# are forwarded back to the Wine application.

writeShellScriptBin "synthv-uri-handler" ''
  set -euo pipefail

  # -- Configuration --
  SYNTHV_PREFIX="''${SYNTHV_PREFIX:-$HOME/.local/share/synthv}"
  SYNTHV_ENV="${synthv-env}/bin"
  XDG_OPEN="${xdg-utils}/bin/xdg-open"
  MKDIR="${coreutils}/bin/mkdir"
  CHMOD="${coreutils}/bin/chmod"

  SYNTHV_EXE="C:\\Program Files\\Synthesizer V Studio 2 Pro\\synthv-studio.exe"
  URI_SCHEME="dreamtonics-svstudio2"
  DESKTOP_NAME="synthv-uri-handler"
  DESKTOP_DIR="''${HOME}/.local/share/applications"
  DESKTOP_FILE="''${DESKTOP_DIR}/''${DESKTOP_NAME}.desktop"
  HANDLER_SCRIPT="''${HOME}/.local/bin/synthv-uri-handler.sh"

  # -- Help --
  show_help() {
    cat <<'HELP'
synthv-uri-handler - Register SynthV URI scheme handler

Usage:
  synthv-uri-handler              Register URI handler
  synthv-uri-handler --unregister Remove URI handler
  synthv-uri-handler --help       Show this help

What this does:
  1. Creates a shell script that forwards dreamtonics-svstudio2:// URIs
     back to the Wine application
  2. Creates a .desktop file with the MIME type
  3. Registers the MIME handler with xdg-mime

After registration, browser OAuth callbacks for SynthV will be
automatically forwarded to the running Wine application.
HELP
  }

  # -- Register URI handler --
  register() {
    echo "Registering ''${URI_SCHEME} URI handler..."

    # Create handler script
    "''${MKDIR}" -p "''${HOME}/.local/bin"
    cat > "''${HANDLER_SCRIPT}" << SCRIPT
#!/usr/bin/env bash
# SynthV URI handler - forwards dreamtonics-svstudio2:// URIs to Wine
export WINEPREFIX="''${SYNTHV_PREFIX}"
export PATH="''${SYNTHV_ENV}:\$PATH"
wine start "''${SYNTHV_EXE}" "\$1"
SCRIPT
    "''${CHMOD}" +x "''${HANDLER_SCRIPT}"
    echo "Created handler script: ''${HANDLER_SCRIPT}"

    # Create .desktop file
    "''${MKDIR}" -p "''${DESKTOP_DIR}"
    cat > "''${DESKTOP_FILE}" << DESKTOP
[Desktop Entry]
Type=Application
Name=Synthesizer V Studio 2 URI Handler
Exec=''${HANDLER_SCRIPT} %u
MimeType=x-scheme-handler/''${URI_SCHEME};
NoDisplay=true
Terminal=false
StartupNotify=false
DESKTOP
    echo "Created .desktop file: ''${DESKTOP_FILE}"

    # Register MIME handler
    "''${XDG_OPEN}" --list 2>/dev/null || true
    xdg-mime default "''${DESKTOP_FILE}" "x-scheme-handler/''${URI_SCHEME}"
    echo "Registered MIME handler for x-scheme-handler/''${URI_SCHEME}"

    # Register Wine registry entries for the URI scheme
    echo "Registering Wine registry entries..."
    export WINEPREFIX="''${SYNTHV_PREFIX}"
    export PATH="''${SYNTHV_ENV}:$PATH"

    wine reg add 'HKEY_CLASSES_ROOT\''${URI_SCHEME}' /ve /t REG_SZ /d "URL Protocol ''${URI_SCHEME}" /f 2>/dev/null || true
    wine reg add 'HKEY_CLASSES_ROOT\''${URI_SCHEME}' /v "URL Protocol" /t REG_SZ /d "" /f 2>/dev/null || true
    wine reg add 'HKEY_CLASSES_ROOT\''${URI_SCHEME}\Default Icon' /ve /t REG_SZ /d "''${SYNTHV_EXE},0" /f 2>/dev/null || true
    wine reg add 'HKEY_CLASSES_ROOT\''${URI_SCHEME}\shell\open\command' /ve /t REG_SZ /d "\"''${SYNTHV_EXE}\" \"%1\"" /f 2>/dev/null || true

    echo ""
    echo "URI handler registered successfully."
    echo "Browser OAuth callbacks for SynthV will now be forwarded to Wine."
  }

  # -- Unregister URI handler --
  unregister() {
    echo "Unregistering ''${URI_SCHEME} URI handler..."

    rm -f "''${HANDLER_SCRIPT}"
    echo "Removed handler script: ''${HANDLER_SCRIPT}"

    rm -f "''${DESKTOP_FILE}"
    echo "Removed .desktop file: ''${DESKTOP_FILE}"

    xdg-mime default "" "x-scheme-handler/''${URI_SCHEME}" 2>/dev/null || true
    echo "Unregistered MIME handler"

    echo ""
    echo "URI handler unregistered."
  }

  # -- Check if registered --
  check_registered() {
    if [[ -f "''${HANDLER_SCRIPT}" ]] && [[ -f "''${DESKTOP_FILE}" ]]; then
      echo "URI handler is registered."
      echo "  Handler: ''${HANDLER_SCRIPT}"
      echo "  Desktop: ''${DESKTOP_FILE}"
    else
      echo "URI handler is NOT registered."
    fi
  }

  # -- Main --
  main() {
    case "''${1:-}" in
      --help)
        show_help
        exit 0
        ;;
      --unregister)
        unregister
        exit 0
        ;;
      --status)
        check_registered
        exit 0
        ;;
    esac

    register
  }

  main "$@"
''
