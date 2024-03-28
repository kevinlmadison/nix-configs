{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      pane_frames = true;
      simplified_ui = true;
      theme = "rose-pine";
      # if pkgs.system == "aarch64-darwin"
      # then "gruvbox-dark"
      # else "dracula";
      # https://github.com/nix-community/home-manager/issues/3854
      themes.gruvbox-dark = {
        fg = [213 196 161];
        bg = [40 40 40];
        black = [60 56 54];
        red = [204 36 29];
        green = [152 151 26];
        yellow = [215 153 33];
        blue = [69 133 136];
        magenta = [177 98 134];
        cyan = [104 157 106];
        white = [251 241 199];
        orange = [214 93 14];
      };
      themes.dracula = {
        fg = [248 248 242];
        bg = [40 42 54];
        black = [0 0 0];
        red = [255 85 85];
        green = [80 250 123];
        yellow = [241 250 140];
        blue = [98 114 164];
        magenta = [255 121 198];
        cyan = [139 233 253];
        white = [255 255 255];
        orange = [255 184 108];
      };

      themes.rose-pine = {
        fg = [224 223 244]; # e0def4
        bg = [25 23 36]; # 191724
        black = [0 0 0]; # 000000
        red = [235 111 146]; # eb6f92
        green = [49 116 143]; # 31748f
        yellow = [246 193 119]; # f6c177
        blue = [156 207 216]; # 9ccfd8
        magenta = [196 167 231]; # c4a7e7
        cyan = [235 188 186]; # ebbcba
        white = [224 223 244]; # e0def4
        orange = [234 154 151]; # #ea9a97
      };
    };
  };
}
