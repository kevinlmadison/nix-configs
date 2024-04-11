{
  pkgs,
  inputs,
  ...
}: {
  home.file = {
    ".config/hypr/hyprland.conf".source = ./linux/hypr/hyprland.conf;
    ".config/hypr/start.sh" = import ./linux/hypr/start.nix;
    ".config/hypr/wallpaper.png".source = ./linux/hypr/wallpaper.png;
  };
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1;
    NIXOS_OZONE_WL = 1;
  };

  home.packages = with pkgs; [
    # utils
    acpi # hardware states
    brightnessctl # Control background
    playerctl # Control audio

    (inputs.hyprland.packages."x86_64-linux".hyprland.override {
      # enableNvidiaPatches = true;
    })
    eww
    wl-clipboard
    rofi-wayland
  ];
}
