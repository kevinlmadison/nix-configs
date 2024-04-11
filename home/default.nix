{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  default_pkgs = with pkgs; [
    gohufont
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
    (python3.withPackages (ps: with ps; [pypy python-lsp-server python-lsp-ruff]))
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
    inputs.neovim-flake.packages.${pkgs.system}.default
    fd
  ];

  linux_pkgs = with pkgs; [firefox zoom-us slack];

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
  imports = [
    # Include the results of the hardware scan.
    ./zellij.nix
    ./kitty.nix
    ./nushell
    ./starship.nix
    ./atuin.nix
    ./files.nix
    # inputs.nixvim.homeManagerModules.nixvim
  ];

  # programs.nushell = import ./nushell {inherit config pkgs;};
  # home.file =
  #   if pkgs.system == "aarch64-darwin"
  #   then {
  #     ".yabairc" = import ./darwin/yabai.nix;
  #     ".skhdrc" = import ./darwin/skhd.nix;
  #   }
  #   else {
  #     ".config/hypr/hyprland.conf" = ./linux/hypr/hyprland.conf;
  #     ".config/hypr/start.sh" = import ./linux/hypr/start.nix;
  #     ".config/hypr/wallpaper.png" = ./linux/hypr/wallpaper.png;
  #     ".config/waybar/config.jsonc" = ./linux/waybar/config.jsonc;
  #     ".config/waybar/mediaplayer.py" = ./linux/waybar/mediaplayer.py;
  #     ".config/waybar/style.css" = ./linux/waybar/style.css;
  #   };
  # else "sudo nixos-rebuild switch --flake ~/repos/nix-configs/#$(hostname) --impure";
  home.sessionVariables.EDITOR = "nvim";
  home.username = "kelevra";
  home.homeDirectory =
    if pkgs.system == "aarch64-darwin"
    then "/Users/kelevra"
    else "/home/kelevra";

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
    ripgrep.enable = true;
    bat.enable = true;
    autojump.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    btop.enable = true;
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
    enableAutosuggestions = true;
    sessionVariables.EDITOR = "nvim";
    sessionVariables.KUBE_EDITOR = "nvim";
    autocd = true;
    history = {
      save = 10000;
      path =
        if pkgs.system == "aarch64-darwin"
        then "/Users/kelevra/.histfile"
        else "/home/kelevra/.histfile";
    };
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
  home.stateVersion = "23.11";
  manual.manpages.enable = true;
}
