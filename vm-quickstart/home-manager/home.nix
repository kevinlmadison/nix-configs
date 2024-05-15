{
  lib,
  inputs,
  pkgs,
  ...
}: let
  source = pkgs.fetchurl {
    url = "https://github.com/rvcas/room/releases/latest/download/room.wasm";
    sha256 = "15xx83yyjb79xr68mwb3cbw5rwm62ryczc0vv1vcpjzsd1visadj";
  };

  # Undo this version lock after closing out of all sessions
  pkgs_0_39_2 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e89cf1c932006531f454de7d652163a9a5c86668.tar.gz";
  }) {};

  default_pkgs = with pkgs; [
    mongosh
    gohufont
    bat
    k9s
    git
    font-awesome
    powerline-fonts
    powerline-symbols
    nerdfonts
    sd
    (python3.withPackages (ps: with ps; [pypy python-lsp-server python-lsp-ruff]))
    nil
    entr
    kubectl
    # awscli
    kubernetes-helm
    helmfile
    terraform
    ansible
    inputs.neovim-flake.packages.${pkgs.system}.default
    fd
    devenv
    pkg-config
    openssl
  ];

  linux_pkgs = with pkgs; [
    clang
    clang-tools
    cmake
    llvm
  ];

  shellAliases = {
    l = "lsd -alF";
    c = "cd";
    e = "nvim";
    gcm = "git commit -m";
    se = "sudoedit";
    sz = "source ~/.zshrc";
    conf = "sudoedit /etc/nixos/configuration.nix";
    sshdemo = "ssh -i ~/repos/platform/k8s/keys/ahq.demo admin@a.demo.analyticshq.com";
    sshdev = "ssh -i ~/repos/platform/k8s/keys/ahq.dev admin@a.dev.analyticshq.com";
    update =
      if pkgs.system == "aarch64-darwin"
      then "darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure"
      else "home-manager switch --flake ~/.config/home-manager --impure";
  };
in {
  nixpkgs.config = {
    allowUnfree = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    KUBE_EDITOR = "nvim";
  };
  home.shellAliases = shellAliases;
  home.packages =
    if pkgs.system == "x86_64-linux"
    then linux_pkgs ++ default_pkgs
    else default_pkgs;
  fonts.fontconfig.enable = true;

  programs = {
    ripgrep.enable = true;
    bat.enable = true;
    autojump.enable = true;
    jq.enable = true;
    nix-index.enable = true;
  };

  programs.direnv = {
    enable = true;
    config = {
      whitelist.prefix = ["~/repos/kubezt"];
      hide_env_diff = true;
    };
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
      icons.when = "auto";
      icons.theme = "fancy";
      date = "relative";
      ignore-globs = [
        ".git"
        ".hg"
      ];
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      KUBE_EDITOR = "nvim";
      TERM = "xterm-256color";
    };
    autocd = true;
    history = {
      save = 10000;
      path =
        if pkgs.system == "aarch64-darwin"
        then "/Users/kubezt/.histfile"
        else "/home/kubezt/.histfile";
    };
    initExtra =
      if pkgs.system == "aarch64-darwin"
      then ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      ''
      else "";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "z"
        "git"
        "sudo"
        "docker"
        "kubectl"
        "vi-mode"
      ];
      theme = "robbyrussell";
    };
  };

  manual.manpages.enable = true;
  home.username = "kubezt";
  home.homeDirectory = "/home/kubezt";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.home-manager.enable = true;
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      aws = {
        symbol = " ";
      };
    };
  };

  home.file.".config/zellij/plugins/room.wasm".source = source;

  programs.zellij = {
    enable = true;
    package = pkgs_0_39_2.zellij;
    settings = {
      keybinds = {
        normal = builtins.listToAttrs (lib.genList (n: {
            name = "bind \"Alt ${toString (n + 1)}\"";
            value = {
              GoToTab = n + 1;
              SwitchToMode = "Normal";
            };
          })
          9);
        shared_except = {
          _args = ["locked"];
          "bind \"Ctrl y\"" = {
            LaunchOrFocusPlugin = {
              _args = ["file:~/.config/zellij/plugins/room.wasm"];
              floating = true;
              ignore_case = true;
            };
          };
          "bind \"Alt f\"" = {
            LaunchPlugin = {
              _args = ["zellij:filepicker"];
              close_on_selection = true;
            };
          };
        };
      };
      default_layout = "compact";
      default_shell = "/home/kubezt/.nix-profile/bin/zsh";
      pane_frames = true;
      simplified_ui = true;
      # copy_clipboard = "primary";
      copy_on_select = false;
      # layout_dir = "~/.config/zellij/layouts";
      theme = "rose-pine";
      # if pkgs.system == "aarch64-darwin"
      # then "gruvbox-dark"
      # else "dracula";
      # https://github.com/nix-community/home-manager/issues/3854
      themes.rose-pine = {
        fg = [224 223 244]; # e0def4
        bg = [25 23 36]; # 191724
        black = [0 0 0]; # 000000
        red = [235 111 146]; # eb6f92
        green = [49 116 143]; # 31748f
        yellow = [246 193 119]; # f6c177
        blue = [156 207 216]; # 9ccfd8
        magenta = [196 167 231]; # c4a7e7
        cyan = [235 188 186]; # ebbcba
        white = [224 223 244]; # e0def4
        orange = [234 154 151]; # #ea9a97
      };
    };
  };
}
