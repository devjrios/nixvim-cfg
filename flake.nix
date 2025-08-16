{
  description = "Personal nixvim config";

  inputs = {
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/9a1e130619ec0b2e16624aef973f6437029e2d17";
    nixpkgs-with-working-jdtls.url = "github:NixOS/nixpkgs/ebbd613587758567d62555cfe91a770148e1a30f";
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
        nixvimLib = inputs.nixvim.lib."${system}";
        nixvim' = inputs.nixvim.legacyPackages."${system}";
        nixvimModule = {
          inherit system;
          module = import ./config;
          extraSpecialArgs = {
            vscode-extensions = inputs.nix-vscode-extensions.extensions."${system}";
            jdtls-pkg = inputs.nixpkgs-with-working-jdtls.legacyPackages."${system}".jdt-language-server;
          };
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
