{
  config,
  pkgs,
  ...
}: let
  system = pkgs.system;
  # linuxBuilderSsh = pkgs.writeShellScriptBin "linux-builder-ssh" ''
  #   sudo ssh -i /etc/nix/builder_ed25519 builder@linux-builder
  # '';
in {
  #nix packages
  # environment.systemPackages = [
  #   linuxBuilderSsh
  # ];

  nix.settings = {
    auto-optimise-store = false;
    # substituters = [
    #   "http://mac-mini:8080/nix-darwin"
    # ];
    # trusted-public-keys = [
    #   "nix-darwin:zqwtaTJFoluKxoYMF6FZXHIzGtPeuKbv7TQZscovOP0="
    # ];
  };

  #homebrew packages
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [
      "unar"
      "yabai"
      "skhd"
      "libiconv"
      "cargo-generate"
      "codecrafters"
      "yq"
      "mas"
      "kubectl-cnpg"
      "kubelogin"
      "exercism"
      # "hashicorp/tap/packer"
      # "pulumi"
      # "func"
      # "apache-spark"
      # "pkg-config"
      # "openssl"
      #   "bash"
      #   "choose-gui"
      #   "cliclick"
      #   "pinentry-mac"
      #   "watch"
      #   "zsh"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
    taps = [
      "koekeishiya/formulae"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "codecrafters-io/tap"
      "knative-extensions/kn-plugins"
      # "hashicorp/tap"
      # "amar1729/formulae"
      # "colindean/fonts-nonfree"
      # "kidonng/malt"
      # "aaronraimist/homebrew-tap"
    ];
    casks = [
      "slack"
      "zoom"
      "firefox"
      "discord"
      "expressvpn"
      "android-file-transfer"
      "google-chrome"
      "chatgpt"
      "claude"
      "anki"
      "transmission"
      "jellyfin"
      "love"
      "signal"
      "ghostty"
      "vnc-viewer"
      "blender"
      "zed"
      "steam"
      #   # "1password-beta"
      #   # "android-platform-tools"
      #   "blockblock"
      #   "cursorcerer"
      #   "font-droid-sans-mono-for-powerline"
      #   "font-iosevka-nerd-font"
      #   "font-jetbrains-mono-nerd-font"
      #   "font-microsoft-office"
      #   "hiddenbar"
      #   # "iterm2"
      #   "knockknock"
      #   "lulu"
      #   # "mullvad-browser"
      # "oversight"
      #   "reikey"
      #   "rustdesk"
      #   "secretive"
      #   "shortcat"
      #   "syncthing"
      #   # "tailscale"
      #   "kitty"
    ];

    masApps = {
      "Ziti Desktop Edge" = 1460484572;
      # DaisyDisk = 411643860;
      # "WiFi Explorer" = 494803304;
      # "Reeder 5." = 1529448980;
      # "1Password for Safari" = 1569813296;
      # "Dark Reader for Safari" = 1438243180;
      # "Redirect Web for Safari" = 1571283503;
      # "Vimlike" = 1584519802;
      # "AdGuard for Safari" = 1440147259;
    };
  };
}
