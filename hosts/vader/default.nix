# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../common/system.nix
      ../common/tailscale.nix
      ./hardware-configuration.nix
      ./jellyfin.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vader"; # Define your hostname.
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_ortho";
  };
  system.stateVersion = "23.11"; # Did you read the comment?

}
