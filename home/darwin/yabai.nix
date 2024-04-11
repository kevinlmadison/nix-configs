{...}: {
  executable = true;
  text = ''
    /opt/homebrew/bin/yabai -m signal --add event=dock_did_restart action="sudo /opt/homebrew/bin/yabai --load-sa"
    sudo /opt/homebrew/bin/yabai --load-sa

    /opt/homebrew/bin/yabai -m config debug_output on

    /opt/homebrew/bin/yabai -m config top_padding    0
    /opt/homebrew/bin/yabai -m config bottom_padding 0
    /opt/homebrew/bin/yabai -m config left_padding   0
    /opt/homebrew/bin/yabai -m config right_padding  0
    /opt/homebrew/bin/yabai -m config window_gap     0

    /opt/homebrew/bin/yabai -m config mouse_modifier ctrl
    /opt/homebrew/bin/yabai -m config mouse_action1 move
    /opt/homebrew/bin/yabai -m config mouse_action2 resize
  '';
}
