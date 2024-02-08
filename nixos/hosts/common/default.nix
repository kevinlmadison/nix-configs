{ config, pkgs, inputs, ... }:
{
  imports =
    [
      (import ./system.nix { inherit inputs config;})
      ./tailscale.nix
    ];
}
