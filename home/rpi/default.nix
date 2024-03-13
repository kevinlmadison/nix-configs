{ config, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  imports =
    [ # Include the results of the hardware scan.
      ./zellij.nix
      ./neovim
      ./starship.nix
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
      # update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-test --impure";
    };

  home.packages = with pkgs; [
    btop
    zlib
    git
    rustup
    nil
  ];
  fonts.fontconfig.enable = true;

  programs = {
    ripgrep.enable = true;
    bat.enable = true;
    autojump.enable = true;
    # jq.enable = true;
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
    envExtra = "export TERM=ansi";
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
