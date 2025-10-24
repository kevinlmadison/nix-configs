{
  pkgs,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        show_symlink = true;
        scrolloff = 4;
      };
      preview = {
        tab_size = 2;
      };
    };
  };
}
