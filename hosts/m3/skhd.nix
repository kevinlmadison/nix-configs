{ ... }: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      #!/usr/bin/env bash

      ctrl - e :  yabai -m space --layout bsp
      ctrl - s :  yabai -m space --layout stack

      ctrl - down :  yabai -m window --focus stack.next || yabai -m window --focus south
      ctrl - up :  yabai -m window --focus stack.prev || yabai -m window --focus north
      ctrl + alt - left :  yabai -m window --focus west
      ctrl + alt - right :  yabai -m window --focus east

      ctrl - 1 :  yabai -m space --focus 1
      ctrl - 2 :  yabai -m space --focus 2
      ctrl - 3 :  yabai -m space --focus 3
      ctrl - 4 :  yabai -m space --focus 4
      ctrl - 5 :  yabai -m space --focus 5
      ctrl - 6 :  yabai -m space --focus 6
      ctrl - 7 :  yabai -m space --focus 7
      ctrl - 8 :  yabai -m space --focus 8
      ctrl - 9 :  yabai -m space --focus 9
      ctrl - 0 :  yabai -m space --focus 0

      ctrl + shift - 1 :  yabai -m window --space 1
      ctrl + shift - 2 :  yabai -m window --space 2
      ctrl + shift - 3 :  yabai -m window --space 3
      ctrl + shift - 4 :  yabai -m window --space 4
      ctrl + shift - 5 :  yabai -m window --space 5
      ctrl + shift - 6 :  yabai -m window --space 6
      ctrl + shift - 7 :  yabai -m window --space 7
      ctrl + shift - 8 :  yabai -m window --space 8
      ctrl + shift - 9 :  yabai -m window --space 9
      ctrl + shift - 0 :  yabai -m window --space 0

      ctrl - f :  yabai -m window --toggle float
      shift + ctrl - c :  yabai -m space --create
      shift + ctrl - d :  yabai -m space --destroy
    '';
  };
}
