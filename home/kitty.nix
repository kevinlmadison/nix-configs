{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    theme = "Rosé Pine";
    font = {
      package = pkgs.gohufont;
      name = "GohuFont 14 Nerd Font";
      size =
        if pkgs.system == "aarch64-darwin"
        then 14
        else 10;
    };
    settings = {
      shell = "${pkgs.zsh}/bin/zsh --login --interactive";
      editor = "nvim";
      confirm_os_window_close = "0";
      background_opacity = "0.93";
      macos_option_as_alt = "yes";
      foreground = "#e0def4";
      background = "#000000";
      selection_foreground = "#e0def4";
      selection_background = "#403d52";
      hide_window_decorations = "titlebar-only";

      cursor = "#524f67";
      cursor_text_color = "#e0def4";

      url_color = "#c4a7e7";

      active_tab_foreground = "#e0def4";
      active_tab_background = "#000000";
      inactive_tab_foreground = "#6e6a86";
      inactive_tab_background = "#111111";

      # black
      color0 = "#26233a";
      color8 = "#6e6a86";

      # red
      color1 = "#eb6f92";
      color9 = "#eb6f92";

      # green
      color2 = "#31748f";
      color10 = "#31748f";

      # yellow
      color3 = "#f6c177";
      color11 = "#f6c177";

      # blue
      color4 = "#9ccfd8";
      color12 = "#9ccfd8";

      # magenta
      color5 = "#c4a7e7";
      color13 = "#c4a7e7";

      # cyan
      color6 = "#ebbcba";
      color14 = "#ebbcba";

      # white
      color7 = "#e0def4";
      color15 = "#e0def4";
    };
  };
}
