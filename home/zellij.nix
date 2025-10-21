{
  pkgs,
  config,
  lib,
  ...
}: let
  source = pkgs.fetchurl {
    url = "https://github.com/rvcas/room/releases/latest/download/room.wasm";
    sha256 = "sha256-t6GPP7OOztf6XtBgzhLF+edUU294twnu0y5uufXwrkw=";
  };

  # Undo this version lock after closing out of all sessions
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/eb0e0f21f15c559d2ac7633dc81d079d1caf5f5f.tar.gz";
  }) {};
in {
  home.file.".config/zellij/plugins/room.wasm".source = source;

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    # package = oldPkgs.zellij;
    settings = {
      keybinds = {
        normal = builtins.listToAttrs (lib.genList (n: {
            name = "bind \"Alt ${toString (n + 1)}\"";
            value = {
              GoToTab = n + 1;
              SwitchToMode = "Normal";
            };
          })
          9);
        # normal = {
        #   "bind \"Alt 1\"" = {
        #     GoToTab = 1;
        #     SwitchToMode = "Normal";
        #   };
        # };
        shared_except = {
          _args = ["locked"];
          "bind \"Ctrl y\"" = {
            LaunchOrFocusPlugin = {
              _args = ["file:~/.config/zellij/plugins/room.wasm"];
              floating = true;
              ignore_case = true;
            };
          };
          "bind \"Alt f\"" = {
            LaunchPlugin = {
              _args = ["zellij:filepicker"];
              close_on_selection = true;
            };
          };
        };
      };
      plugins = {
        compact-bar = {
          _props = {
            location = "zellij:compact-bar";
          };
          tooltip = "F2";
        };
      };
      default_layout = "compact";
      pane_frames = true;
      simplified_ui = true;
      # layout_dir = "~/.config/zellij/layouts";
      theme = "ansi";
      # theme = "rose-pine";
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
      themes.kanagawa = {
        text_unselected = {
          base = [220 215 186];
          background = [22 22 29];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        text_selected = {
          base = [22 22 29];
          background = [118 148 106];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        ribbon_selected = {
          base = [22 22 29];
          background = [118 148 106];
          emphasis_0 = [195 64 67];
          emphasis_1 = [255 160 102];
          emphasis_2 = [149 127 184];
          emphasis_3 = [126 156 216];
        };
        ribbon_unselected = {
          base = [22 22 29];
          background = [220 215 186];
          emphasis_0 = [195 64 67];
          emphasis_1 = [220 215 186];
          emphasis_2 = [126 156 216];
          emphasis_3 = [149 127 184];
        };
        table_title = {
          base = [118 148 106];
          background = [0];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        table_cell_selected = {
          base = [22 22 29];
          background = [118 148 106];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        table_cell_unselected = {
          base = [220 215 186];
          background = [22 22 29];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        list_selected = {
          base = [22 22 29];
          background = [118 148 106];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        list_unselected = {
          base = [220 215 186];
          background = [22 22 29];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [118 148 106];
          emphasis_3 = [149 127 184];
        };
        frame_selected = {
          base = [118 148 106];
          background = [0];
          emphasis_0 = [255 160 102];
          emphasis_1 = [127 180 202];
          emphasis_2 = [149 127 184];
          emphasis_3 = [0];
        };
        frame_highlight = {
          base = [255 160 102];
          background = [0];
          emphasis_0 = [149 127 184];
          emphasis_1 = [255 160 102];
          emphasis_2 = [255 160 102];
          emphasis_3 = [255 160 102];
        };
        exit_code_success = {
          base = [118 148 106];
          background = [0];
          emphasis_0 = [127 180 202];
          emphasis_1 = [22 22 29];
          emphasis_2 = [149 127 184];
          emphasis_3 = [126 156 216];
        };
        exit_code_error = {
          base = [195 64 67];
          background = [0];
          emphasis_0 = [255 158 59];
          emphasis_1 = [0];
          emphasis_2 = [0];
          emphasis_3 = [0];
        };
        multiplayer_user_colors = {
          player_1 = [149 127 184];
          player_2 = [126 156 216];
          player_3 = [0];
          player_4 = [255 158 59];
          player_5 = [127 180 202];
          player_6 = [0];
          player_7 = [195 64 67];
          player_8 = [0];
          player_9 = [0];
          player_10 = [0];
        };
      };
    };
  };
}
