# FAQ

## General

### What is this project?

A Nix flake that provides a reproducible Wine environment for running
Synthesizer V Studio 2 on NixOS.

### Does this include Synthesizer V?

No. SynthV is proprietary software. You must provide your own installer,
voice databases, and licenses.

### Why Wine instead of native?

SynthV Studio 2 is a Windows-only application. Wine is the most mature
compatibility layer for running Windows applications on Linux.

## Installation

### Can I install without the NixOS module?

Yes. The packages are available directly via `nix shell` or `nix run`.
See [Installation Guide](./installation.md).

### Where is the Wine prefix created?

Default location: `~/.local/share/synthv`

Override with the `SYNTHV_PREFIX` environment variable.

## Usage

### How do I install voice databases?

Copy the voice database installer into the prefix and run it with Wine:

```bash
cp voice_db_installer.exe ~/.local/share/synthv/drive_c/
cd ~/.local/share/synthv/drive_c
wine voice_db_installer.exe
```

### How do I log in?

Launch SynthV, click the login button, and authenticate in the browser
window that opens. See the Authentication section in the README.

## Troubleshooting

### SynthV crashes on launch

Try a different Wine version or reset the prefix. See
[Troubleshooting](./troubleshooting.md).

### Audio is broken

Ensure PulseAudio or PipeWire is running. Check `pactl info`.
