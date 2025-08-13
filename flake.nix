{
  description = "Personal nixvim config";

  inputs = {
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    flake-parts.follows = "nixvim/flake-parts";
    nixpkgs.follows = "nixvim/nixpkgs";
    systems.follows = "nixvim/systems";
  };

  nixConfig = {
    allow-import-from-derivation = false;
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        lib,
        system,
        pkgs,
        ...
      }: let
        nixvimLib = inputs.nixvim.lib.${system};
        nixvim' = inputs.nixvim.legacyPackages."${system}";
        nixvimModule = {
          inherit system;
          module = import ./config;
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        formatter = pkgs.alejandra;
        checks = {
          # nix flake check .
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };
        packages = {
          # nix run .
          default = nvim;
        };
      };
    };
}
