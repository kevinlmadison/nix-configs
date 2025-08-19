{
  config,
  pkgs,
  inputs,
  ...
}:
# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
let
  system = pkgs.system;
in {
  imports = [
    ./tailscale.nix
    ./sketchybar.nix
    ./pkgs.nix
    ./ollama.nix
    # ./nixvim
    # inputs.nixvim.nixDarwinModules.nixvim
    # ./yabai.nix
    # ./skhd.nix
  ];

  documentation.man.enable = true;
  environment.systemPackages = with pkgs; [
    git
    fzf
    watch
    colima
    docker
    istioctl
    dpkg
    pv
    # kmonad
    # libiconv
    # pkg-config
  ];

  # https://github.com/nix-community/home-manager/issues/4026
  users.users.kelevra = {
    home = "/Users/kelevra";
    name = "kelevra";
    shell = pkgs.zsh;
  };

  # services.nix-daemon.enable = true;
  # services.kmonad = {
  #   enable = true;
  #   keyboards = {
  #     myKMonadOutput = {
  #       device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  #       config = builtins.readFile /Users/kelevra/.config/kmonad/miryoku_kmonad.kbd;
  #     };
  #   };
  # };
  nix.enable = true;
  nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  # nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

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
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
  programs.nix-index.enable = true;

  environment.shells = with pkgs; [
    bashInteractive
    freshfetch
    zsh
    nushell
  ];

  #system-defaults.nix
  system.primaryUser = "kelevra";
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
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;
}
