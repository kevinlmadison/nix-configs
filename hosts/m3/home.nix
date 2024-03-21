{ config, pkgs, lib, inputs, ... }: {

  imports =
    [ # Include the results of the hardware scan.
      ./zellij.nix
      ./starship.nix
      ./nushell
    ];

  home.username = "kelevra";
  home.homeDirectory = "/Users/kelevra";
  home.sessionVariables.LIBRARY_PATH = ''${lib.makeLibraryPath [pkgs.libiconv]}''${LIBRARY_PATH:+:$LIBRARY_PATH}'';
  home.shellAliases = {
      l = "lsd -alF";
      c = "cd";
      e = "nvim";
      gcm = "git commit -m";
      se = "sudoedit";
      update = "darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure";
    };

  home.packages = with pkgs; [
    cmatrix
    bat
    k9s
    git
    rustup
    #firefox  # Not supported on aarch64-darwin
    font-awesome
    powerline-fonts
    powerline-symbols
    nerdfonts
    sd
    (python3.withPackages(ps: with ps; [ pypy python-lsp-server python-lsp-ruff]))
    nil
    clang
    clang-tools
    cmake
    llvm
    entr
    kubectl
    gohufont
    awscli
    kubernetes-helm
    helmfile
    terraform
    ansible
  ];
  fonts.fontconfig.enable = true;

  programs = {
    ripgrep.enable = true;
    bat.enable = true;
    autojump.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    htop.enable = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = false;
    settings = {
      theme = "gruvbox";
      editor.line-number = "relative";
      editor.cursor-shape.insert = "bar";
      editor.lsp.enable = true;
      editor.lsp.display-messages = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "kevinlmadison";
    userEmail = "coolklm121@gmail.com";
  };

  programs.home-manager.enable = true;
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      macos_option_as_alt = "yes";
    };
    font = {
      package = pkgs.gohufont;
      name = "GohuFont 14 Nerd Font";
      size = 13;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 8;
        normal = {
          family = "GohuFont";
          style  = "Regular";
        };
        bold = {
          family = "GohuFont";
          style  = "Bold";
        };
      };

      shell.program = "zsh";
      decorations = "None";
      opacity = 0.8;
      startup_mode = "Fullscreen";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lsd = {
    enable = true;
    settings = {
      icons.when = "never";
      date = "relative";
      ignore-globs = [
        ".git"
        ".hg"
      ];
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;
    initExtraFirst = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    history = {
      save = 10000;
      path = "/Users/kelevra/.histfile";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["z" "git" "sudo" "docker" "kubectl" ];
      theme = "robbyrussell";
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
  manual.manpages.enable = true;
}
