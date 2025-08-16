{
  description = "Personal nixvim config";

  inputs = {
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/028a172309c9eeb8d8f6d9d19130d703d51fde93";
    nixpkgs-with-working-jdtls.url = "github:NixOS/nixpkgs/62659a8ca7bba5d151365ff641b74439181725c0";
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
