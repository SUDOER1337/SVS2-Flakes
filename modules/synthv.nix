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
        Username for documentation purposes.
        Desktop integration should be configured via home-manager.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.winePackage
      pkgs.synthv-bootstrap
      pkgs.synthv-launcher
    ];
  };
}
