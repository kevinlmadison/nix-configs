{pkgs, ...}: {
  home.file =
    if pkgs.system == "aarch64-darwin"
    then {
      ".yabairc" = import ./darwin/yabai.nix;
      ".skhdrc" = import ./darwin/skhd.nix;
    }
    else {
      ".config/hypr/hyprland.conf" = ./linux/hypr/hyprland.conf;
      ".config/hypr/start.sh" = import ./linux/hypr/start.nix;
      ".config/hypr/wallpaper.png" = ./linux/hypr/wallpaper.png;
      ".config/waybar/config.jsonc" = ./linux/waybar/config.jsonc;
      ".config/waybar/mediaplayer.py" = ./linux/waybar/mediaplayer.py;
      ".config/waybar/style.css" = ./linux/waybar/style.css;
    };
}
