# Known Issues

## Current (Last Updated: 2026-08-27)

- **Login URI Scheme** — SynthV uses `dreamtonics-synthesizer://` for OAuth.
  The browser redirects to this URI, but Wine does not natively handle it.
  A custom `.desktop` URI handler is required to forward the callback.
  See `docs/authentication.md` for the planned implementation.
- **dxvk + WebView2 rendering** — Requires DXVK for Direct2D rendering
  and WebView2 installed separately. Both must be present for the login
  dialog to render (not just display a blank window).
- **Wine Version Mismatch** — SynthV's WebView2 login dialog requires
  Windows 10 (`win10`) to install, but WebView2 renders blank until the
  prefix is set back to `win7` after installation. Current workaround:
  install WebView2 with `win10`, then switch to `win7` for runtime.

## Working (Verified 2026-08-27)

- **Wine 11.0 (wineWow64Packages.stable)** — Works for installation
  and basic launch with DXVK.
- **DXVK 3.0.2** — Required for Direct2D rendering in SynthV UI.
  Installed via `winetricks dxvk`.
- **WebView2 (EdgeWebView)** — Installed manually from Microsoft's
  evergreen bootstrapper. Found at:
  `~/.local/share/synthv/drive_c/Program Files (x86)/Microsoft/EdgeWebView/Application/`

## Completed Work

- [x] Wine prefix created at `~/.local/share/synthv` (win64)
- [x] Core + Pro installers executed; `synthv-studio.exe` present
- [x] `synthv2` launcher discovers and runs `synthv-studio.exe`
- [x] DXVK installed via `winetricks dxvk`
- [x] WebView2 installed via Microsoft bootstrapper
- [x] UI renders (menus, dropdowns functional)
- [x] WebView2 subprocesses launch with `--edge-webview-custom-scheme`

## Mitigations

Until URI handler is automated:

1. Install DXVK:
   ```bash
   WINEPREFIX=~/.local/share/synthv winetricks dxvk
   ```
2. Set Windows version to 10 for WebView2 installation:
   ```bash
   WINEPREFIX=~/.local/share/synthv winetricks win10
   ```
3. Download and run WebView2 bootstrapper:
   ```bash
   wget -O ~/.local/share/synthv/drive_c/MicrosoftEdgeWebview2Setup.exe \
     "https://go.microsoft.com/fwlink/p/?LinkId=2124703"
   WINEPREFIX=~/.local/share/synthv wine ~/.local/share/synthv/drive_c/MicrosoftEdgeWebview2Setup.exe
   ```
4. Switch to Windows 7 (fixes WebView2 rendering in SynthV):
   ```bash
   WINEPREFIX=~/.local/share/synthv winetricks win7
   ```
5. Kill lingering Edge processes:
   ```bash
   WINEPREFIX=~/.local/share/synthv wineserver -k
   ```

## Upstream

- SynthV is not tested against all Wine versions.
- Wine's implementation of WebView2 is partial.
- Login flow requires `synthv://` URI handler (Wine cannot handle this natively).
