{ config, lib, pkgs, ... }:
# === Module: services.synthv ===
#   Provides managed Wine environment for Synthesizer V Studio 2.
#
#   services.synthv = {
#     enable = true;
#     user   = "myuser";
#   };
#
#   Creates:
#     - System packages (synthv-env, synthv-bootstrap, synthv2)
#     - XDG desktop entry for SynthV

let
  cfg = config.services.synthv;
in
{
  options.services.synthv = {
    enable = lib.mkEnableOption "Synthesizer V Studio 2 environment";

    winePackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.synthv-env;
      defaultText = lib.literalExpression "pkgs.synthv-env";
      description = "Wine environment package to use for SynthV.";
    };

    prefixDir = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/.local/share/synthv";
      defaultText = lib.literalExpression ''"$HOME/.local/share/synthv"'';
      description = "Path to the SynthV Wine prefix.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "myuser";
      description = ''
        Username to configure desktop integration for.
        Required for the application menu entry.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.winePackage
      pkgs.synthv-bootstrap
      pkgs.synthv-launcher
    ];

    # -- Desktop entry --
    xdg.desktopEntries."synthv2" = lib.mkIf (cfg.user != "") {
      name = "Synthesizer V Studio 2";
      genericName = "AI Singing Synthesis";
      exec = "synthv2";
      icon = "synthv";
      categories = [ "Audio" "AudioVideo" ];
      comment = "Synthesizer V Studio 2 – AI singing synthesis";
    };
  };
}
