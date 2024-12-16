{
  plugins.treesitter = {
    enable = true;

    nixvimInjections = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    folding = true;
  };
  
  plugins.treesitter-refactor = {
    enable = true;
    highlightDefinitions = {
      enable = true;
      # Set to false if you have an `updatetime` of ~100.
      clearOnCursorMove = false;
    };
  };
  plugins.hmts.enable = true;
}
