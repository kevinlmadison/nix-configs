{...}: {
  executable = true;
  text = ''
    #!/usr/bin/env bash

    # initializing wallpaper daemon
    swww-daemon &

    # setting wallpaper
    swww img ~/.config/hypr/wallpaper.png &

    nm-applet --indicator &

    waybar &

    dunst &
  '';
}
