{
  config,
  pkgs,
  inputs,
  stateVersion,
  username,
  lib,
  ...
}: let
  yq_pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
  }) {};

  myPkg = yq_pkgs.yq;
  font_packages = with pkgs; [
    # nerdfonts
    # nerd-fonts.hack
    # nerd-fonts.droid-sans-mono
    # nerd-fonts.iosevka
    nerd-fonts._3270
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.daddy-time-mono
    nerd-fonts.departure-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.inconsolata
    nerd-fonts.inconsolata-go
    nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.lekton
    nerd-fonts.liberation
    nerd-fonts.lilex
    nerd-fonts.martian-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.noto
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono
    nerd-fonts.shure-tech-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
  ];

  default_pkgs = with pkgs; [
    # cool rust rewrites of posix tools
    # myPkg
    sd # sed
    fd # find
    procs # ps
    dust # du
    tokei
    hyperfine
    bandwhich
    grex
    bat-extras.batgrep
    wget
    cosign
    xdelta
    argocd
    skopeo
    func
    cmake
    vcpkg
    # zig
    zls
    # openai-whisper
    # whisper-cpp
    # kn
    # faas-cli

    jekyll
    ruby_3_4

    nixos-rebuild
    gohufont
    cmatrix
    k9s
    git
    dig
    rustup
    font-awesome
    powerline-fonts
    powerline-symbols
    # nerdfonts
    python3
    # (python311.withPackages (ps:
    #   with ps; [
    #     python-lsp-server
    #     python-lsp-ruff
    #     python-lsp-black
    #     pylsp-rope
    #     pylsp-mypy
    #     pyls-isort
    #   ]))
    nil
    entr
    kubectl
    istioctl
    stern
    # awscli2
    kubernetes-helm
    # helmfile
    ansible
    inputs.neovim-flake.packages.${pkgs.system}.default
    inputs.zig.packages.${pkgs.system}.master
    # inputs.kmonad.packages.${pkgs.system}.default
    devenv
    pkg-config
    openssl
    wireshark
    kubeshark
    mongosh
    go
  ];

  linux_pkgs = with pkgs; [
    clang
    clang-tools
    kanshi
    # libstdcxx5
    ghostty
    llvm
    firefox
    zoom-us
    slack
    acpi # hardware states
    brightnessctl # Control background
    playerctl # Control audio
    xdg-desktop-portal

    # (inputs.hyprland.packages."x86_64-linux".hyprland.override {
    #   # enableNvidiaPatches = true;
    # })
    eww
    wl-clipboard
    rofi-wayland
  ];

  home_dir =
    if pkgs.system == "aarch64-darwin"
    then "/Users/${username}"
    else "/home/${username}";

  shellAliases = {
    l = "lsd -alF";
    c = "cd";
    e = "nvim";
    diff = "delta";
    gcm = "git commit -m";
    se = "sudoedit";
    sz = "source ~/.zshrc";
    tg = "batgrep";
    sshkzt = "ssh -i ~/repos/kubezt/k8s/keys/$CLUSTER_NAME/$CLUSTER_NAME admin@a.$(echo $CLUSTER_NAME | awk -F'-' '{print $2}' ).kubezt.com";
    update =
      if pkgs.system == "aarch64-darwin"
      then "sudo NIXPKGS_ALLOW_BROKEN=1 darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure"
      else "sudo nixos-rebuild switch --flake ~/repos/nix-configs/#$(hostname) --impure";
  };
in {
  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = [
    ./zellij.nix
    ./nushell
    ./starship.nix
    ./atuin.nix
    ./files.nix
    ./k9s.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    KUBE_EDITOR = "nvim";
    WLR_NO_HARDWARE_CURSORS = 1;
    NIXOS_OZONE_WL = 1;
    RUSTUP_HOME = "${home_dir}/.local/share/rustup";
    LIBRARY_PATH = "/opt/homebrew/lib:/opt/homebrew/opt/libiconv/lib";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  home.sessionPath = [
    "~/.cargo/bin"
    "/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin"
  ];

  home.username = username;
  home.homeDirectory = home_dir;

  home.shellAliases = lib.mkForce shellAliases;
  home.packages =
    if pkgs.system == "x86_64-linux"
    then linux_pkgs ++ default_pkgs ++ font_packages
    else default_pkgs ++ font_packages;
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  programs.man.enable = true;
  programs = {
    # cool rust rewrites of posix tools
    ripgrep.enable = true;
    tealdeer.enable = true;
    bat.enable = true;

    autojump.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    btop.enable = true;
  };

  programs.direnv = {
    enable = true;
    config = {
      whitelist.prefix = ["~/repos/kubezt/k8s"];
      hide_env_diff = true;
    };
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
    delta = {
      enable = true;
      options = {
        syntax-theme = "gruvbox-dark";
        dark = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 8;
        normal = {
          family = "GohuFont";
          style = "Regular";
        };
        bold = {
          family = "GohuFont";
          style = "Bold";
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
    enableZshIntegration = false;
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
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      KUBE_EDITOR = "nvim";
      WLR_NO_HARDWARE_CURSORS = 1;
      NIXOS_OZONE_WL = 1;
      RUSTUP_HOME = "${home_dir}/.local/share/rustup";
      LIBRARY_PATH = "/opt/homebrew/lib:/opt/homebrew/opt/libiconv/lib";
      TERM = "xterm-256color";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
    autocd = true;
    history = {
      save = 10000;
      path =
        if pkgs.system == "aarch64-darwin"
        then "/Users/${username}/.histfile"
        else "/home/${username}/.histfile";
    };

    initContent =
      ''
        zitisec() {
                echo; \
                kubectl -n kubezt get secrets ziti-controller-admin-secret \
                  -o go-template='{{index .data "admin-password" | base64decode }}'; \
                echo;
              }
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        ziticp() {
                kubectl -n kubezt get secrets ziti-controller-admin-secret \
                  -o go-template='{{index .data "admin-password" | base64decode }}' \
                  | pbcopy
              }
      ''
      + lib.optionalString (pkgs.system == "x86_64-linux") ''
        ziticp() {
                kubectl -n kubezt get secrets ziti-controller-admin-secret \
                  -o go-template='{{index .data "admin-password" | base64decode }}' \
                  | wl-copy
              }
      '';

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

  services = lib.optionalAttrs (pkgs.system == "x86_64-linux") {
    kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";

      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              scale = 2.0;
              status = "enable";
            }
          ];
        };

        home_office = {
          outputs = [
            {
              criteria = "DP-3";
              position = "0,0";
              mode = "1920x1080@60Hz";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        };
      };
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = stateVersion;
  manual.manpages.enable = true;
}
