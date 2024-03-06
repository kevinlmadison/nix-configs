{ config, pkgs, ... }:

let
  user = "kelevra";
  password = "testtest";
in
{
  imports = [ ./tailscale.nix ];

  networking.networkmanager.enable = true;
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


  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users."${user}" = {
    isNormalUser = true;
    description = "Kevin Madison";
    extraGroups = [ "networkmanager" "wheel" "dbus"];
    shell = pkgs.zsh;
    password = password;
    #packages = with pkgs; [
    #  firefox
    ##  thunderbird
    #];
  };
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    trusted-users = ["kelevra"];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    killall
    git
    fzf
    zsh
    gnumake
    gcc
    curl
    (import ../scripts/swap_kb_layout.nix { inherit pkgs; })
  ];

  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };
  programs.ssh.startAgent = true;
  programs.pam.enableSSHAgentAuth = true; 
  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];
  networking.firewall.allowedTCPPorts = [ 22 ];
}
