{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./system.nix
      ./tailscale.nix
    ];
}
