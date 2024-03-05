{ pkgs, inputs, ... }: 
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
let
  system = pkgs.system;
in {
  imports = [
      ./tailscale.nix
      ./yabai.nix
  ];

  environment.systemPackages = with pkgs; [ 
    neovim
    git
    fzf
    kitty
    clang
  ];

  # https://github.com/nix-community/home-manager/issues/4026
  users.users.kelevra = {
    home = "/Users/kelevra";
    name = "kelevra";
  };

  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  # nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # nix configuration
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "@admin"
        "kelevra"
      ];
    };
    linux-builder = {
      enable = true;
      package = pkgs.darwin.linux-builder;
    };
  };
  services.activate-system.enable = true;
  programs.nix-index.enable = true;

  environment.shells = with pkgs; [
    bashInteractive
    freshfetch
    zsh
  ];

  # add nerd fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "DroidSansMono" "Iosevka" ]; })
  ];

  #system-defaults.nix
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
      mineffect = "genie";
      launchanim = true;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
      mru-spaces = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      CreateDesktop = false; # disable desktop icons
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      Dragging = true;
    };
    # Apple firewall config:
    alf = {
      globalstate = 2;
      loggingenabled = 0;
      stealthenabled = 1;
    };
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # set dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      _HIHideMenuBar = true;
    };
    CustomUserPreferences = {
      "NSGlobalDomain" = {
        "AppleSpacesSwitchOnActivate" = 0; # Do not automatically refocus spaces
      };
      "com.googlecode.iterm2" = {
        "PrefsCustomFolder" = "~/.config/iterm2";
        "LoadPrefsFromCustomFolder" = 1;
      };
      "org.gpgtools.common" = {
        "UseKeychain" = "NO";
        "DisableKeychain" = "yes";
      };
    };
  };
   # Add flake support
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  # Use touch ID for sudo auth
  security.pam.enableSudoTouchIdAuth = true;
}
