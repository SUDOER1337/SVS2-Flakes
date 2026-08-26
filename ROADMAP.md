# ROADMAP.md

# SynthV on NixOS Flake

## Project Goal

Create a reusable Nix flake that allows NixOS users to run Synthesizer V Studio 2 with minimal manual setup.

The flake should provide:

- Wine environment
- Required runtime dependencies
- Launcher scripts
- Desktop integration
- Reproducible configuration
- Documentation

The flake should NOT redistribute proprietary software.

Users must supply their own:

- Synthesizer V installer
- Voice databases
- Licenses
- Login credentials

---

# Agent Operating Rules

## Human-In-The-Loop

The user is responsible for:

- Authentication
- Browser logins
- Proprietary downloads
- License acceptance
- Providing installer files

If any of these are required:

STOP.

Explain what is needed and ask the user.

Do not attempt to bypass authentication or licensing requirements.

---

## Safety

Before making changes:

1. Explain intended action.
2. Explain affected files.
3. Explain risks.
4. Request confirmation for destructive operations.

Never:

- Delete user data without confirmation.
- Replace existing Wine prefixes without confirmation.
- Modify boot configuration without confirmation.

---

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

---

# Phase 0: Research ✅

## Objective

Determine the current compatibility status of SynthV on Linux.

## Tasks

Investigate:

- Known working Wine versions
- Known broken Wine versions
- Required Winetricks packages
- WebView2 requirements
- Authentication requirements
- Existing community solutions

## Deliverables

Document:

Compatibility matrix

Known issues

Required dependencies

Success Criteria:

Compatibility information collected.

Required components identified.

## Status (2026-08-27)

- Wine 11.0 (wineWow64Packages.stable) works with DXVK
- DXVK required for Direct2D rendering
- WebView2 required for login dialog
- URI handler required for `dreamtonics-synthesizer://` OAuth callback

---

# Phase 1: Environment Discovery ✅

## Objective

Inspect host system.

## Tasks

Determine:

NixOS version

Nixpkgs version

Flake or non-flake setup

Desktop environment

Wayland or X11

Available Wine packages

Check for:

Existing SynthV installations

Existing Wine prefixes

Existing launcher scripts

## Deliverables

Environment report.

## Success Criteria:

Host environment fully understood.

## Status (2026-08-27)

- NixOS host `thallix`, user `doer`
- Flake-based config at `~/nixos-config`
- Wine available via `wineWow64Packages.stable`

---

# Phase 2: Base Flake Structure ✅

## Objective

Create reusable project structure.

## Tasks

Create:

flake.nix

packages/

modules/

scripts/

docs/

README.md

ROADMAP.md

Establish:

Formatting

Linting

Documentation standards

## Deliverables

Initial repository structure.

## Success Criteria:

Repository evaluates successfully.

## Status (2026-08-27)

- 18 files committed and pushed to GitHub
- Flake evaluates with `nix flake check`
- Dev shell with nixd + nixfmt + alejandra

---

# Phase 3: Wine Environment ✅

## Objective

Provide managed Wine environment.

## Tasks

Package:

Wine

Winetricks

Supporting utilities

Evaluate:

staging

stable

alternative Wine builds

Select default runner.

## Deliverables

pkgs.synthv-env

## Success Criteria:

Environment launches successfully.

## Status (2026-08-27)

- `wineWow64Packages.stable` selected (Wine 11.0)
- `winetricks` available in PATH
- Kron4ek wine removed (incompatible with wow64)

---

# Phase 4: Prefix Management ✅

## Objective

Provide isolated SynthV Wine prefix.

## Tasks

Create:

synthv-bootstrap

Responsibilities:

Create prefix

Initialize prefix

Validate prefix

Detect corruption

Upgrade prefix safely

Avoid:

Using ~/.wine

Default location:

~/.local/share/synthv

## Deliverables

Bootstrap tool.

## Success Criteria:

Prefix created automatically.

## Status (2026-08-27)

- Prefix at `~/.local/share/synthv`
- `system.reg` shows `#arch=win64`
- Windows version set to win10 (for WebView2 install), then win7 (for runtime)

---

# Phase 5: Dependency Installation ⚠️

## Objective

Install Windows runtime requirements.

## Tasks

Automate:

dotnet45

WebView2

Additional required components

Investigate:

Exact versions required

Document:

Installation process

Known issues

## Deliverables

Automated dependency setup.

## Success Criteria:

Dependencies install cleanly.

## Status (2026-08-27)

**Partially completed:**

- DXVK 3.0.2 installed via `winetricks dxvk`
- WebView2 installed from Microsoft's evergreen bootstrapper
- Both required for UI rendering + login dialog

**Not yet automated:**

- Steps are manual (need `synthv-deps` package)

**Blocking:**

- Win7 mode needed after WebView2 install (WebView2 renders blank on win10)

---

# Phase 6: SynthV Installation ✅

## Objective

Install proprietary application.

## Tasks

Request installer from user.

Validate:

File exists

File type

Version

Install into managed prefix.

Record:

Installation path

Installed version

Human Action Required

User supplies installer.

## Deliverables

Working installation.

## Success Criteria:

Application launches.

## Status (2026-08-27)

- Core installer (`svstudio2-core-setup-latest.exe`) installed
- Pro installer (`svstudio2-pro-setup-latest.exe`) installed
- `synthv-studio.exe` found at:
  `~/.local/share/synthv/drive_c/Program Files/Synthesizer V Studio 2 Pro/`
- Launcher discovers and runs it

---

# Phase 7: Authentication Support ⚠️

## Objective

Ensure login functionality works.

## Tasks

Investigate:

Browser authentication

URI handlers

Protocol registration

Implement:

Desktop handler support

Document:

User login workflow

Human Action Required

User performs login.

## Deliverables

Functional authentication.

## Success Criteria:

User can authenticate successfully.

## Status (2026-08-27)

**Not yet implemented:**

- `dreamtonics-synthesizer://` URI handler required
- Wine cannot natively handle custom URI schemes
- Need `.desktop` file + handler script

---

# Phase 8: Launcher Integration ✅

## Objective

Provide user-friendly execution.

## Tasks

Create:

synthv2 launcher

Responsibilities:

Configure environment

Set WINEPREFIX

Launch executable

Support:

CLI launch

Desktop launch

## Deliverables

Launcher package.

## Success Criteria:

Single command launches SynthV.

## Status (2026-08-27)

- `synthv2` command works
- Sets `WINEPREFIX`, `WINEDEBUG`, `WINEDLLOVERRIDES`
- Auto-discovers `synthv-studio.exe` via `find`

---

# Phase 9: Desktop Integration ⏳

## Objective

Integrate with Linux desktop.

## Tasks

Generate:

.desktop file

Icons

MIME entries

URI handlers

Verify:

Application menu visibility

## Deliverables

Desktop integration package.

## Success Criteria:

Application appears in launcher menu.

## Status (2026-08-27)

**Not started:**

- NixOS module stripped of `xdg.desktopEntries` (home-manager only)
- Will need home-manager integration or manual `.desktop` file

---

# Phase 10: NixOS Module ✅

## Objective

Provide reusable NixOS module.

## Tasks

Create:

services.synthv.enable

Potential options:

services.synthv = {

enable = true;

winePackage = ...;

prefixDir = ...;

};

Generate:

Launchers

Desktop entries

Environment configuration

## Deliverables

Reusable module.

## Success Criteria:

Module enables SynthV environment.

## Status (2026-08-27)

- Module at `modules/synthv.nix`
- Overlay at `packages/overlay.nix`
- Both integrated into `~/nixos-config`

---

# Phase 11: Testing ⏳

## Objective

Validate functionality.

## Test Matrix

Verify:

Launch

Login

Project creation

Audio playback

Voice loading

Saving projects

Reopening projects

Test:

Fresh installation

Existing installation

Upgrades

## Deliverables

Test report.

## Success Criteria:

All critical functionality works.

## Status (2026-08-27)

**In progress:**

- Launch: ✅ Working
- Login: ⏳ URI handler not yet implemented
- UI rendering: ✅ Working (DXVK)
- WebView2: ✅ Installed and rendering

---

# Phase 12: Documentation ⏳

## Objective

Prepare project for public use.

## Tasks

Write:

README.md

Installation Guide

Troubleshooting Guide

FAQ

Compatibility Notes

Known Issues

## Deliverables

Complete documentation.

## Success Criteria:

New user can install without developer assistance.

## Status (2026-08-27)

- README.md: ✅
- Installation Guide: ✅ (needs dependency steps)
- Troubleshooting Guide: ✅ (needs DXVK/WebView2 section)
- Known Issues: ✅ (updated with working status)
- Compatibility Matrix: ⏳ Not started
- FAQ: ⏳ Not started

---

## Future Goals

Potential future work:

- Home Manager module
- Multiple Wine profiles
- Automated compatibility testing
- Version pinning profiles
- Community-maintained compatibility database
- CI evaluation testing
- URI handler package (`synthv-uri-handler`)

---

## Definition of Done

Project is complete when:

- [ ] Flake evaluates successfully ✅
- [ ] Environment is reproducible ✅
- [ ] SynthV launches ✅
- [ ] Login works ⏳
- [ ] Audio works ⏳
- [ ] Desktop integration works ⏳
- [ ] Documentation is complete ⏳
- [ ] User confirms successful installation ⏳
