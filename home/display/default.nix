{
  pkgs,
  inputs,
  ...
}: {
  imports =
    if pkgs.system == "aarch64-darwin"
    then [./darwin.nix]
    else [
      (import ./hyprland.nix {inherit inputs pkgs;})
      ./waybar.nix
    ];
}
