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
    zoom-us
    slack
    inputs.neovim-flake.packages.${pkgs.system}.default
  ];

  linux_pkgs = with pkgs; [firefox];
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
    # ./nixvim
    # inputs.nixvim.homeManagerModules.nixvim
  ];

  home.username = "kelevra";
  home.homeDirectory =
    if pkgs.system == "aarch64-darwin"
    then "/Users/kelevra"
    else "/home/kelevra";
  home.shellAliases = {
    l = "lsd -alF";
    c = "cd";
    e = "nvim";
    gcm = "git commit -m";
    se = "sudoedit";
    conf = "sudoedit /etc/nixos/configuration.nix";
    update =
      if pkgs.system == "aarch64-darwin"
      then "darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure"
      else "sudo nixos-rebuild switch --flake ~/repos/nix-configs/#$(hostname) --impure";
  };

  home.packages =
    if pkgs.system == "x86_64-linux"
    then linux_pkgs ++ default_pkgs
    else default_pkgs;
  fonts.fontconfig.enable = true;

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
      plugins = ["z" "git" "sudo" "docker" "kubectl"];
      theme = "robbyrussell";
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
  manual.manpages.enable = true;
}
