{
  description = "Personal nixvim config";

  inputs.nixvim.url = "github:nix-community/nixvim";

  outputs = {
    self,
    nixvim,
    flake-parts,
  } @ inputs: let
    cfg = {
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
        nvim = nixvim'.makeNixvim ({lib, ...} : cfg);
      in {
        packages = {
          inherit nvim;
          default = nvim;
        };
      };

  };
}
