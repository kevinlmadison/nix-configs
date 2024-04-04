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
    };
  };
}
