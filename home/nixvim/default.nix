{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./keymaps.nix
    ./style.nix
    ./telescope.nix
    ./treesitter.nix
    ./harpoon.nix
    ./folds.nix
    ./lsp.nix
    ./completion.nix
    ./format.nix
    ./lint.nix
    ./debug.nix
    ./gitsigns.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    globals = {
      mapleader = " ";
    };

    options = {
      number = true;
      colorcolumn = "80";
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      wrap = false;
      swapfile = false; #Undotree
      backup = false; #Undotree
      undofile = true;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      foldlevelstart = 99;
      clipboard = "unnamedplus";
      breakindent = true;
      completeopt = "menu,menuone,noselect";
    };

    highlight = {
      Comment.fg = "#ff00ff";
      Comment.bg = "#000000";
      Comment.underline = true;
      Comment.bold = true;
    };

    plugins = {
      cursorline = {
        enable = true;
        cursorline = {
          enable = true;
          timeout = 0;
          number = true;
        };
      };
      oil.enable = true;
      undotree.enable = true;
      fugitive.enable = true;
      nvim-tree.enable = true;
      indent-blankline.enable = true;
      friendly-snippets.enable = true;
      comment-nvim.enable = true;
      surround.enable = true;
      navic.enable = true;
      # mini.modules.pairs = {};
      nvim-autopairs.enable = true;
      nvim-autopairs.checkTs = true;
      ts-context-commentstring.enable = true;
      which-key = {
        enable = true;
        registrations = {
          "<leader>c" = {
            name = "[C]ode";
            _ = "which_key_ignore";
          };
          "<leader>d" = {
            name = "[D]ocument";
            _ = "which_key_ignore";
          };
          "<leader>g" = {
            name = "[G]it";
            _ = "which_key_ignore";
          };
          "<leader>h" = {
            name = "Git [H]unk";
            _ = "which_key_ignore";
          };
          "<leader>r" = {
            name = "[R]ename";
            _ = "which_key_ignore";
          };
          "<leader>s" = {
            name = "[S]earch";
            _ = "which_key_ignore";
          };
          "<leader>t" = {
            name = "[T]oggle";
            _ = "which_key_ignore";
          };
          "<leader>w" = {
            name = "[W]orkspace";
            _ = "which_key_ignore";
          };
        };
      };
    };
    extraPackages = with pkgs; [
      # Formatters
      alejandra
      # asmfmt
      # astyle
      ansible-language-server
      black
      cmake-format
      gofumpt
      golines
      gotools
      isort
      nodePackages.prettier
      prettierd
      rustfmt
      shfmt
      stylua
      # Linters
      # commitlint
      # eslint_d
      ansible-lint
      golangci-lint
      # hadolint
      # html-tidy
      luajitPackages.luacheck
      markdownlint-cli
      nodePackages.jsonlint
      pylint
      ruff
      shellcheck
      nil
      # vale
      yamllint
      # Debuggers / misc deps
      # asm-lsp
      # bashdb
      # clang-tools
      # delve
      # fd
      # gdb
      ansible
      go
      # lldb_17
      # llvmPackages_17.bintools-unwrapped
      marksman

      # (nerdfonts.override {
      #   fonts = [
      #     "JetBrainsMono"
      #     "RobotoMono"
      #   ];
      # })

      python3
      ripgrep
      # rr
      # tmux-sessionizer
      zig
    ];
  };
}
