{...}: {
  executable = true;
  text = ''
    #!/usr/bin/env bash

    cmd - e :  /opt/homebrew/bin/yabai -m space --layout bsp
    cmd - s :  /opt/homebrew/bin/yabai -m space --layout stack

    cmd - down :  /opt/homebrew/bin/yabai -m window --focus stack.next || yabai -m window --focus south
    cmd - up :  /opt/homebrew/bin/yabai -m window --focus stack.prev || yabai -m window --focus north
    cmd + alt - left :  /opt/homebrew/bin/yabai -m window --focus west
    cmd + alt - right :  /opt/homebrew/bin/yabai -m window --focus east

    cmd - 1 :  /opt/homebrew/bin/yabai -m space --focus 1
    cmd - 2 :  /opt/homebrew/bin/yabai -m space --focus 2
    cmd - 3 :  /opt/homebrew/bin/yabai -m space --focus 3
    cmd - 4 :  /opt/homebrew/bin/yabai -m space --focus 4
    cmd - 5 :  /opt/homebrew/bin/yabai -m space --focus 5
    cmd - 6 :  /opt/homebrew/bin/yabai -m space --focus 6
    cmd - 7 :  /opt/homebrew/bin/yabai -m space --focus 7
    cmd - 8 :  /opt/homebrew/bin/yabai -m space --focus 8
    cmd - 9 :  /opt/homebrew/bin/yabai -m space --focus 9
    cmd - 0 :  /opt/homebrew/bin/yabai -m space --focus 0

    cmd + shift - 1 :  /opt/homebrew/bin/yabai -m window --space 1
    cmd + shift - 2 :  /opt/homebrew/bin/yabai -m window --space 2
    cmd + shift - 3 :  /opt/homebrew/bin/yabai -m window --space 3
    cmd + shift - 4 :  /opt/homebrew/bin/yabai -m window --space 4
    cmd + shift - 5 :  /opt/homebrew/bin/yabai -m window --space 5
    cmd + shift - 6 :  /opt/homebrew/bin/yabai -m window --space 6
    cmd + shift - 7 :  /opt/homebrew/bin/yabai -m window --space 7
    cmd + shift - 8 :  /opt/homebrew/bin/yabai -m window --space 8
    cmd + shift - 9 :  /opt/homebrew/bin/yabai -m window --space 9
    cmd + shift - 0 :  /opt/homebrew/bin/yabai -m window --space 0

    cmd - f :  /opt/homebrew/bin/yabai -m window --toggle float
    shift + cmd - c :  /opt/homebrew/bin/yabai -m space --create
    shift + cmd - d :  /opt/homebrew/bin/yabai -m space --destroy
  '';
}
