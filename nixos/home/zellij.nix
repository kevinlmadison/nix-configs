{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      #theme = if pkgs.system == "aarch64-darwin" then "dracula" else "gruvbox-dark";
      default_layout = "compact";
      pane_frames = true;
      simplified_ui = true;
      theme = if pkgs.system == "aarch64-darwin" then "gruvbox-dark" else "dracula";
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
        fg = [ 248 248 242 ];
        bg = [ 40 42 54 ];
        black = [ 0 0 0 ];
        red = [ 255 85 85 ];
        green = [ 80 250 123 ];
        yellow = [ 241 250 140 ];
        blue = [ 98 114 164 ];
        magenta = [ 255 121 198 ];
        cyan = [ 139 233 253 ];
        white = [ 255 255 255 ];
        orange = [ 255 184 108 ];
      };
    };
  };

  # home.packages = [
  #   # Open zellij by prompting for CWD
  #   (pkgs.nuenv.mkScript {
  #     name = "zux";
  #     script = ''
  #       let PRJ = (zoxide query -i)
  #       let NAME = ($PRJ | parse $"($env.HOME)/{relPath}" | get relPath | first | str replace -a / ／)
  #       echo $"Launching zellij for ($PRJ)"
  #       cd $PRJ ; exec zellij attach -c $NAME
  #     '';
  #   })
  # ];
}
