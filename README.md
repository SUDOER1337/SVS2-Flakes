# SVS2-Flakes

**Synthesizer V Studio 2 on NixOS** — a reusable Nix flake that provides
a managed Wine environment for running SynthV with minimal manual setup.

## Features

- Reproducible Wine environment via Nix
- Managed Wine prefix (no `~/.wine` pollution)
- Bootstrap tool to create and validate the prefix
- Launcher script with auto-discovery of SynthV executable
- Optional NixOS module with desktop integration
- XDG desktop entry for application menu visibility

## Quick Start

```bash
# Add to your flake inputs, enable the module, rebuild.
# Then:
synthv-bootstrap          # create the Wine prefix
wine SynthV_Installer.exe  # install SynthV
synthv2                    # launch
```

See [Installation Guide](./docs/installation.md) for detailed steps.

## Structure

```
.
├── flake.nix                 # Flake entry point
├── packages/
│   ├── overlay.nix           # Package overlay
│   ├── synthv-env/           # Wine + Winetricks environment
│   ├── synthv-bootstrap/     # Prefix bootstrap tool
│   └── synthv-launcher/      # SynthV launcher
├── modules/
│   └── synthv.nix            # NixOS module (services.synthv)
├── scripts/
│   ├── synthv-bootstrap.sh   # Raw bootstrap script
│   └── synthv-launcher.sh    # Raw launcher script
├── docs/
│   ├── installation.md
│   ├── troubleshooting.md
│   ├── compatibility.md
│   ├── faq.md
│   └── known-issues.md
├── README.md
└── ROADMAP.md
```

## Packages

| Package            | Description                              |
|--------------------|------------------------------------------|
| `synthv-env`       | Wine + Winetricks combined environment   |
| `synthv-bootstrap` | Create/manage/validate the Wine prefix   |
| `synthv-launcher`  | Discover and launch SynthV executable    |

## NixOS Module

```nix
{
  services.synthv = {
    enable = true;
    user   = "myuser";  # for desktop entry
  };
}
```

## Authentication

SynthV uses browser-based OAuth. When you click Login in the app, a
browser window should open. Complete the login there, then return to
SynthV.

*Note: `synthv://` URI handler support is planned but not yet implemented.*

## Status

This project is in early development. See [ROADMAP.md](./ROADMAP.md) for
the planned phases. See [Known Issues](./docs/known-issues.md) for
current limitations.

## License

The Nix code and documentation in this repository are licensed under MIT.

*Synthesizer V Studio 2 is proprietary software of Dreamtonics /
AH-Software. This project is not affiliated with or endorsed by
Dreamtonics or AH-Software.*
