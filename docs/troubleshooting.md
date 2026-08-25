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

Set Wine to use a virtual desktop if the SynthV window does not render:

```bash
winecfg
# → Graphics → Emulate a virtual desktop → 1920x1080
```

## Getting Help

- Check [Known Issues](./known-issues.md)
- Search the [NixOS Discourse](https://discourse.nixos.org/)
- Open an issue on the [repository](https://github.com/SUDOER1337/SVS2-Flakes)
