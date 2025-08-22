{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./tailscale.nix
  ];

  networking.networkmanager.enable = true;
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  documentation.man.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs.hyprland.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = false;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.blueman.enable = true;
  services.pulseaudio.enable = false;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.sudo.configFile = ''
    %wheel ALL=(ALL) ALL
  '';
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  # programs.nushell.enable = true;
  users.users.kelevra = {
    isNormalUser = true;
    description = "Kevin Madison";
    extraGroups = ["networkmanager" "wheel" "dbus" "docker"];
    shell = pkgs.zsh;
    #packages = with pkgs; [
    #  firefox
    ##  thunderbird
    #];
  };
  # nix.buildMachines = [
  #   {
  #     hostName = "vader";
  #     system = "x86_64-linux";
  #     protocol = "ssh-ng";
  #     # if the builder supports building for multiple architectures,
  #     # replace the previous line by, e.g.
  #     # systems = ["x86_64-linux" "aarch64-linux"];
  #     maxJobs = 1;
  #     speedFactor = 2;
  #     supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #     mandatoryFeatures = [];
  #   }
  # ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.settings = {
    experimental-features = ["flakes" "nix-command"];
    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = ["kelevra" "nixremote"];

    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      # the default public key of cache.nixos.org, it's built-in, no need to add it here
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    kanshi
    discord
    killall
    git
    fzf
    zsh
    nushell
    fd
    wezterm
    lm_sensors
    #clang
    #lsd
    #tmux
    dtc
    gnumake
    gcc
    bc
    wget
    networkmanagerapplet
    dunst
    waybar
    libnotify
    swww
    rofi-wayland
    xfce.thunar
    xfce.thunar-volman
    (import ../scripts/k_reload.nix {inherit pkgs;})
    (import ../scripts/swap_kb_layout.nix {inherit pkgs;})
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk]; #pkgs.xdg-desktop-portal-kde];
  #
  #  Some programs need SUID wrappers, can be configured further or are
  ## started in user sessions.
  ## programs.mtr.enable = true;
  ## programs.gnupg.agent = {
  #    enable = true;
  ##   enableSSHSupport = true;
  ## };
  #
  ## List services that you want to enable:
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
    };
  };
  ## Enable the OpenSSH daemon.
  programs.ssh.startAgent = true;
  security.pam.sshAgentAuth.enable = true;
  security.pam.sshAgentAuth.authorizedKeysFiles = lib.mkForce ["/etc/ssh/authorized_keys.d/%u"];
  services.openssh = {
    enable = true;
    ports = [22];
    # settings = {
    #   PasswordAuthentication = false;
    #   KbdInteractiveAuthentication = false;
    # };
  };

  #
  ## Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
