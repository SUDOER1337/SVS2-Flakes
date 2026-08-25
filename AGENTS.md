# SVS2-Flakes – Agent Guide

Nix flake that provides a managed Wine environment for running **Synthesizer V Studio 2** on NixOS.

**Owner**: Nullfjord / SUDOER1337 (GitHub: `SUDOER1337`)

---

## Flake Structure

| Output | Entry | Description |
|--------|-------|-------------|
| `nixosModules.default` | `modules/synthv.nix` | `services.synthv` NixOS module |
| `overlays.default` | `packages/overlay.nix` | Package overlay |
| `packages.default` | `synthv-launcher` | `synthv2` launcher script |
| `devShells.default` | inline in `flake.nix` | nixd + nixfmt + alejandra |

Packages:
- **`synthv-env`** — `wineWow64Packages.stable` + `winetricks` (combined via `symlinkJoin`)
- **`synthv-bootstrap`** — creates/validates the Wine prefix at `~/.local/share/synthv`
- **`synthv-launcher`** — the `synthv2` command; searches prefix for `SynthV*.exe`, `synthesizerv*.exe`, `Synthesizer V*.exe`

## Key Commands

```bash
# Check flake evaluates (lint equivalent — no test suite exists yet)
nix flake check

# Format all .nix files
nixfmt **/*.nix

# Enter dev shell (nixd + nixfmt + alejandra)
nix develop

# User-facing workflow
synthv-bootstrap           # create ~/.local/share/synthv prefix
wine svstudio2-core-setup-latest.exe  # install SynthV into the prefix
synthv2                    # launch SynthV
synthv-bootstrap --destroy # remove prefix (requires 'yes' confirmation)
```

## Critical Conventions

- **Arch**: `x86_64-linux` only
- **Default Wine**: `wineWow64Packages.stable` (wine-stable, not staging or wayland)
- **Wine prefix**: `~/.local/share/synthv` — override via `SYNTHV_PREFIX` env var
- **Bootstrap validation**: checks `$SYNTHV_PREFIX/system.reg` exists as a health check
- **Launcher**: sets `WINEDLLOVERRIDES=winemenubuilder.exe=d` to suppress Wine desktop dialogs
- **Module options**: `services.synthv.{enable, winePackage, prefixDir, user}`
- **Scoring** defaults `WINEARCH=win64` — no win32 support

## Human-in-the-Loop Rules (from ROADMAP.md)

**STOP and ask the user** when any of these are needed:
- Authentication / browser logins
- Proprietary downloads (installer, voice databases)
- License acceptance
- Providing installer files

Do not attempt to bypass authentication or licensing requirements.

**Safety** — before destructive ops (prefix destroy, config modification, data deletion):
1. Explain intended action
2. Explain affected files
3. Explain risks
4. Request confirmation

## Known Missing Features

- WebView2 not yet automated (needed for login dialog)
- dotnet45 not yet automated
- `synthv://` URI handler not implemented
- No CI, no tests, no compatibility matrix data yet

## Reproducibility First

Prefer:
1. Nix modules
2. Flake packages
3. Generated desktop entries
4. Wrapper scripts

Avoid:
1. Manual system modifications
2. Global Wine configuration
3. Undocumented state
