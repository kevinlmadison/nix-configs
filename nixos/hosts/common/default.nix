{ config, pkgs, inputs, ... }:
{
  imports =
    [
      (import ./system.nix { inherit inputs;})
      ./tailscale.nix
    ];
}
