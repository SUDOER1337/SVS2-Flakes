# Troubleshooting Guide

## Common Issues

### "Wine prefix not found"

Run `synthv-bootstrap` first to create the prefix.

### "Synthesizer V executable not found"

SynthV is not installed in the managed prefix. Run the official installer
inside the prefix:

```bash
cd ~/.local/share/synthv/drive_c
wine /path/to/svstudio2-core-setup-latest.exe
```

### Application fails to start

Check the Wine prefix health:

```bash
synthv-bootstrap  # re-runs validation
```

Try resetting the prefix:

```bash
synthv-bootstrap --destroy  # confirm with 'yes'
synthv-bootstrap             # recreate
```

### No audio

Ensure PulseAudio or PipeWire is running. Wine typically uses PulseAudio
on NixOS automatically.

```bash
pactl info
```

### Login issues

SynthV authentication may require a browser. See the Authentication section
in the README for the login workflow.

### Graphics issues

SynthV requires DXVK for Direct2D rendering. If the window appears blank
or menus don't render:

```bash
WINEPREFIX=~/.local/share/synthv winetricks dxvk
```

### WebView2 not rendering login dialog

SynthV's login uses WebView2 which requires:

1. Windows version set to `win10` for installation
2. Windows version set to `win7` for runtime rendering

```bash
# Set to win10 for WebView2 installation
WINEPREFIX=~/.local/share/synthv winetricks win10

# Download and install WebView2
wget -O ~/.local/share/synthv/drive_c/MicrosoftEdgeWebview2Setup.exe \
  "https://go.microsoft.com/fwlink/p/?LinkId=2124703"
WINEPREFIX=~/.local/share/synthv wine ~/.local/share/synthv/drive_c/MicrosoftEdgeWebview2Setup.exe

# Switch to win7 for rendering
WINEPREFIX=~/.local/share/synthv winetricks win7

# Kill lingering Edge processes
WINEPREFIX=~/.local/share/synthv wineserver -k
```

## Getting Help

- Check [Known Issues](./known-issues.md)
- Search the [NixOS Discourse](https://discourse.nixos.org/)
- Open an issue on the [repository](https://github.com/SUDOER1337/SVS2-Flakes)
