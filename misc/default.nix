{
  imports = [
    ./styles.nix
    ./keymappings.nix
  ];
  
  enableMan = false;
  withRuby = false;
  withPython3 = false;
  withNodeJs = false;
  withPerl = false;

  performance = {
    byteCompileLua.enable = true;
    combinePlugins.enable = true;
  };

  luaLoader.enable = true;

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0;
    loaded_perl_provider = 0;
    loaded_python_provider = 0;
  };
  clipboard = {
    register = "unnamedplus";
    providers.xclip.enable = true;
  };
  opts = {
    # Tabs options
    autoindent = true;
    expandtab = true; # tabs as spaces
    shiftwidth = 4;
    tabstop = 4;

    # Word wrapping
    textwidth = 0;
    foldlevel = 99;
    wrap = false;

    fileencoding = "utf-8"; # File-content encoding for the current buffer
    termguicolors = true; # Enables 24-bit RGB color in the |TUI|
    spell = false; # Highlight spelling mistakes (local to window)
    relativenumber = true; # Relative line numbers
    number = true; # Display the absolute line number of the current line

    hidden = true; # Keep closed buffer open in the background
    splitbelow = true; # A new window is put below the current one
    splitright = true; # A new window is put right of the current one

    incsearch = true; # Incremental search: show match for partly typed search command
    inccommand = "split"; # Search and replace: preview changes in quickfix list
    ignorecase = true; # case insensitive queries
    smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper case characters
    
    undofile = true; # Automatically save and restore undo history
    swapfile = false; # Disable the swap file

    modelines = 100; # Sets the type of modelines
    modeline = true; # Tags such as 'vim:ft=sh'

    mouse = "a"; # Enable mouse control
    mousemodel = "extend"; # Mouse right-click extends the current selection
    scrolloff = 8; # Number of screen lines to show around the cursor
    cursorline = false; # Highlight the screen line of the cursor
    cursorcolumn = false; # Highlight the screen column of the cursor
    signcolumn = "yes"; # Whether to show the signcolumn
    colorcolumn = "100"; # Columns to highlight
    laststatus = 3; # When to use a status line for the last window

    updatetime = 100; # Faster completion
  };
}
