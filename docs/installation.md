# Installation Guide

## Prerequisites

- NixOS (or Nix with flakes enabled)
- Synthesizer V Studio 2 installer (`.exe`)
- Synthesizer V voice database files (if any)
- Valid Synthesizer V license / login credentials

## Quick Start

### 1. Add the flake to your system

```nix
# flake.nix
{
  inputs.svs2-flakes.url = "github:SUDOER1337/SVS2-Flakes";

  outputs = { self, nixpkgs, svs2-flakes, ... }: {
    nixosConfigurations.mybox = nixpkgs.lib.nixosSystem {
      modules = [
        svs2-flakes.nixosModules.default
        {
          services.synthv.enable = true;
          services.synthv.user = "myuser";
        }
      ];
    };
  };
}
```

### 2. Rebuild

```bash
sudo nixos-rebuild switch --flake .
```

### 3. Bootstrap the Wine prefix

```bash
synthv-bootstrap
```

This creates `~/.local/share/synthv` and initializes a Win64 Wine prefix.

### 4. Install Synthesizer V

Place the official installer in the prefix and run it:

```bash
cp svstudio2-core-setup-latest.exe ~/.local/share/synthv/drive_c/
cd ~/.local/share/synthv/drive_c
wine svstudio2-core-setup-latest.exe
```

### 5. Install Dependencies (DXVK + WebView2)

SynthV requires DXVK for rendering and WebView2 for the login dialog:

```bash
synthv-deps
```

This installs DXVK, sets up WebView2, and configures the correct Windows
version for rendering.

### 6. Launch

```bash
synthv2
```

Or find "Synthesizer V Studio 2" in your application menu.

## Without the NixOS Module

If you don't want the system module, use the packages directly:

```bash
# Enter a shell with the environment
nix shell github:SUDOER1337/SVS2-Flakes

# Then bootstrap and install as above
synthv-bootstrap
synthv2
```

## Updating

```bash
nix flake update
sudo nixos-rebuild switch --flake .
```

## Uninstalling

1. Disable the module: `services.synthv.enable = false`
2. Rebuild: `sudo nixos-rebuild switch --flake .`
3. Optionally remove the prefix: `synthv-bootstrap --destroy`
