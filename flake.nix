{
  description = "Synthesizer V Studio 2 on NixOS – managed Wine environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # -- NixOS Module --
      nixosModules.synthv = import ./modules/synthv.nix;
      nixosModules.default = self.nixosModules.synthv;

      # -- Overlay --
      overlays.synthv = import ./packages/overlay.nix;
      overlays.default = self.overlays.synthv;

      # -- Packages (per-system) --
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.synthv ];
          };
        in
        rec {
          synthv-env = pkgs.synthv-env;
          synthv-bootstrap = pkgs.synthv-bootstrap;
          synthv-launcher = pkgs.synthv-launcher;
          default = synthv-launcher;
        }
      );

      # -- Dev shell --
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [ nixd nixfmt alejandra ];
          };
        }
      );
    };
}
