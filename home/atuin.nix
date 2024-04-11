{...}: {
  programs.atuin = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      # sync_address = "https://nepal";
      key_path = "~/.config/atuin_key.txt";
      auto_sync = true;
      filter_mode = "global";
      dialect = "us";
      enter_accept = false;
      sync.records = true;
      keymap_mode = "vim-normal";
      filter_mode_shell_up_key_binding = "session";
    };
  };
}
