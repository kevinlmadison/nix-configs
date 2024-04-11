{pkgs, ...}: {
  home.file =
    if pkgs.system == "aarch64-darwin"
    then {
      ".yabairc" = import ./darwin/yabai.nix;
      ".skhdrc" = import ./darwin/skhd.nix;
    }
    else {
      ".config/hypr/hyprland.conf".source = ./linux/hypr/hyprland.conf;
      ".config/hypr/start.sh" = import ./linux/hypr/start.nix;
      ".config/hypr/wallpaper.png".source = ./linux/hypr/wallpaper.png;
      ".config/waybar/config.jsonc".source = ./linux/waybar/config.jsonc;
      ".config/waybar/mediaplayer.py".source = ./linux/waybar/mediaplayer.py;
      ".config/waybar/style.css".source = ./linux/waybar/style.css;
    };
}
