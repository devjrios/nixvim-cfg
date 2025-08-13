{
  imports = [
    ./misc
    ./plugins
  ];

  wrapRc = true;
  impureRtp = false;

  enableMan = false;
  withRuby = false;
  withPython3 = false;
  withNodeJs = false;
  withPerl = false;

  performance = {
    byteCompileLua.enable = true;
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "hmts.nvim"
        "nvim-treesitter"
      ];
    };
  };

  luaLoader.enable = true;

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0;
    loaded_perl_provider = 0;
    loaded_python_provider = 0;
    loaded_python3_provider = 0;
    loaded_node_provider = 0;
  };
}
