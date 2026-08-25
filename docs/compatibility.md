# Compatibility

## Wine Versions

| Wine Version | Status        | Notes                           |
|------------- |---------------|---------------------------------|
| wine-stable  | Untested      | Default runner                  |
| wine-staging | Untested      | May improve audio/graphics      |
| wine-wayland | Untested      | Requires `wineWowPackages.wayland` |

*This matrix will be updated as testing is completed.*

## Host System

| Component   | Requirement                   |
|-------------|-------------------------------|
| NixOS       | 24.05 or later                |
| nixpkgs     | nixos-unstable recommended    |
| Arch        | x86_64 (Wine requirement)     |
| Display     | X11 or Wayland (with XWayland) |
| Audio       | PulseAudio or PipeWire        |

## SynthV Versions

| SynthV Version | Status   | Notes |
|----------------|----------|-------|
| SVD 2.x        | Untested |       |

## Known Working Configurations

*None documented yet — see [Known Issues](./known-issues.md).*
