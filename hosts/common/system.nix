{ config, pkgs, ... }:
{
  imports = [
      ./tailscale.nix
  ];

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = false;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  users.users.kelevra = {
    isNormalUser = true;
    description = "Kevin Madison";
    extraGroups = [ "networkmanager" "wheel" "dbus"];
    shell = pkgs.zsh;
    #packages = with pkgs; [
    #  firefox
    ##  thunderbird
    #];
  };
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = ["kelevra"];

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
    killall
    git
    fzf
    zsh
    wezterm
    kitty
    clang
    #lsd
    #tmux
    wget
    networkmanagerapplet
    dunst
    waybar
    libnotify
    swww
    rofi-wayland
    xfce.thunar
    (import ../scripts/k_reload.nix { inherit pkgs; })
  ];

  #programs.zsh.enable = true;
  #programs.zsh.ohMyZsh = {
  #  enable = true;
  #  plugins = ["z" "git" "sudo" "docker" "kubectl" ];
  #  theme = "robbyrussell";
  #};
  #programs.hyprland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-hyprland];
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
    
  ## Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.openssh.ports = [ 33557 ];
   #
  ## Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 33557 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}