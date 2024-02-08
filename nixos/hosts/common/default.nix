{ config, pkgs, inputs, ... }:
{
  imports =
    [
      (import ./system.nix { inherit config pkgs inputs;})
      ./tailscale.nix
    ];
}
