{
  imports = [
    ./barbar.nix
    ./comment.nix
    ./markdown-preview.nix
    ./telescope.nix
    ./treesitter.nix
    ./clang.nix
    ./misc.nix
  ];
  plugins.lsp = {
    enable = true;
    inlayHints = true;
    keymaps = {
      silent = true;
      diagnostic = {
        # Navigate in diagnostics
        "<leader>k" = "goto_prev";
        "<leader>j" = "goto_next";
      };
      lspBuf = {
        gd = "definition";
        gD = "references";
        gt = "type_definition";
        gi = "implementation";
        K = "hover";
        "<F2>" = "rename";
      };
    };
  };
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
}
