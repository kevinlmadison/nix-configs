{ pkgs, ... }: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      mouse_follows_focus = "on";

      window_opacity = "off";
      window_shadow = "float";

      layout = "bsp";

      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };

    extraConfig = ''
      yabai -m rule --add app='System Settings' manage=off
      yabai -m space 1 --label code    
      yabai -m space 2 --label www     
      yabai -m space 3 --label chat    
      yabai -m space 4 --label music   
      yabai -m space 5 --label five    
      yabai -m space 6 --label six     
      yabai -m space 7 --label seven   
      yabai -m space 8 --label eight   
      # yabai -m rule --add app="Kitty" space=code             
      # yabai -m rule --add app="Google Chrome" space=www      
      # yabai -m rule --add app="Microsoft Teams" space=chat   
      # yabai -m rule --add app="Slack" space=chat             
      # yabai -m rule --add app="Signal" space=chat            
      # yabai -m rule --add app="WhatsApp" space=chat          
      # yabai -m rule --add app="Tidal" space=music
    '';
  };
  # };
}
