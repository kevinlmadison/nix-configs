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

    nixos-rebuild
    gohufont
    cmatrix
    k9s
    git
    rustup
    font-awesome
    powerline-fonts
    powerline-symbols
    # nerdfonts
    (python311.withPackages (ps:
      with ps; [
        # python-lsp-server
        python-lsp-ruff
        # python-lsp-black
        pylsp-rope
        pylsp-mypy
        pyls-isort
      ]))
    nil
    entr
    kubectl
    awscli
    kubernetes-helm
    helmfile
    terraform
    ansible
    inputs.neovim-flake.packages.${pkgs.system}.default
    inputs.kmonad.packages.${pkgs.system}.default
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
    cmake
    llvm
    firefox
    zoom-us
    slack
    acpi # hardware states
    brightnessctl # Control background
    playerctl # Control audio

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

  darwin_imports = [
    ./display/darwin.nix
  ];

  linux_imports = [
    ./display/hyprland.nix
    ./display/waybar.nix
  ];

  base_imports = [
    ./zellij.nix
    ./kitty.nix
    ./nushell
    ./starship.nix
    ./atuin.nix
  ];

  shellAliases = {
    l = "lsd -alF";
    c = "cd";
    e = "nvim";
    diff = "delta";
    gcm = "git commit -m";
    se = "sudoedit";
    sz = "source ~/.zshrc";
    tg = "batgrep";
    conf = "sudoedit /etc/nixos/configuration.nix";
    sshdemo = "ssh -i ~/repos/platform/k8s/keys/ahq.demo admin@a.demo.analyticshq.com";
    sshdev = "ssh -i ~/repos/platform/k8s/keys/ahq.dev admin@a.dev.analyticshq.com";
    sshgov = "ssh -i ~/repos/platform/k8s/keys/ahq.gov admin@a.gov.analyticshq.com";
    update =
      if pkgs.system == "aarch64-darwin"
      then "darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure"
      else "sudo nixos-rebuild switch --flake ~/repos/nix-configs/#$(hostname) --impure";
  };
in {
  nixpkgs.config = {
    allowUnfree = true;
  };
  # imports =
  #   if pkgs.system == "aarch64-darwin"
  #   then darwin_imports ++ base_imports
  #   else linux_imports ++ base_imports;
  imports = [
    # Include the results of the hardware scan.
    ./zellij.nix
    ./kitty.nix
    ./nushell
    ./starship.nix
    ./atuin.nix
    ./files.nix
    # ./rust/cargo-generate.nix
    # ./display
    # (import ./display {inherit inputs pkgs;})
    # inputs.nixvim.homeManagerModules.nixvim
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
    "/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbink"
  ];

  home.username = username;
  home.homeDirectory = home_dir;

  home.shellAliases = shellAliases;
  home.packages =
    if pkgs.system == "x86_64-linux"
    then linux_pkgs ++ default_pkgs
    else default_pkgs;
  fonts.fontconfig.enable = true;

  # programs.nixvim = {
  #   defaultEditor = true;
  #   enable = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   package = inputs.neovim-flake.packages.${pkgs.system}.default;
  # };

  programs.home-manager.enable = true;
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
      whitelist.prefix = ["~/repos/platform/k8s"];
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
    autosuggestion.enable = true;
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

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = stateVersion;
  manual.manpages.enable = true;
}
