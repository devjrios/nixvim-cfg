{
  description = "Personal nixvim config";

  inputs.nixvim.url = "github:nix-community/nixvim/nixos-24.11";

  outputs = {
    self,
    nixvim,
    flake-parts,
  } @ inputs: let
    config = {
      imports = [
        ./misc
        ./plugins
      ];
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        lib,
        system,
        ...
      }: let
        nixvim' = nixvim.legacyPackages."${system}";
        nvim = nixvim'.makeNixvim ({lib, ...} : config);
      in {
        packages = {
          inherit nvim;
          default = nvim;
        };
      };
    };
}
