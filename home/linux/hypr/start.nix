{...}: {
  executable = true;
  text = ''
    #!/usr/bin/env bash

    # initializing wallpaper daemon
    swww init &

    # setting wallpaper
    swww img ~/.config/hypr/wallpaper.png &

    nm-applet --indicator &

    waybar &

    dunst &
  '';
}
