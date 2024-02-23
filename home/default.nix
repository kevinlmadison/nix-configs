{ config, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  imports =
    [ # Include the results of the hardware scan.
      ./tmux.nix
      ./zellij.nix
      ./neovim
      ./nushell
      ./starship.nix
      # ./wayland.nix
      # ./waybar.nix
    ];

  home.username = "kelevra";
  home.homeDirectory = "/home/kelevra";
  home.shellAliases = {
      l = "lsd -alF";
      c = "cd";
      e = "nvim";
      gcm = "git commit -m";
      se = "sudoedit";
      conf = "sudoedit /etc/nixos/configuration.nix";
      # update = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-test --impure";
    };

  home.packages = with pkgs; [
    cmatrix
    mpd
    bat
    btop
    zlib
    pypy3
    k9s
    git
    arandr
    rustup
    firefox
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

  programs.git = {
    enable = true;
    userName = "kevinlmadison";
    userEmail = "coolklm121@gmail.com";
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.gohufont;
      name = "GohuFont 14 Nerd Font";
      size = 10;
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
    history = {
      save = 10000;
      path = "/home/kelevra/.histfile";
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
