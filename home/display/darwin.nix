{...}: {
  home.file = {
    ".yabairc" = import ./darwin/yabai.nix;
    ".skhdrc" = import ./darwin/skhd.nix;
  };
}
