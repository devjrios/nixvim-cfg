{
  # https://clangd.llvm.org/installation#compile_commandsjson
  # https://clang.llvm.org/docs/JSONCompilationDatabase.html
  plugins.lsp.servers.clangd = {
    enable = true;
    rootDir = ''
    function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { "Makefile", "CMakeLists.txt", "compile_commands.json", ".gitignore", ".gitattributes", ".git" },
          { upward = true }
        )[1]
      )
    end
    '';
  };
  plugins.clangd-extensions.enable = true;
}
