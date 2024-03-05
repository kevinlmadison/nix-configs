{ pkgs, inputs, ... }: 

let
  system = pkgs.system;
in
{

  services.yabai = {
    enable = true;
    # enableScriptingAddition = true;
    package = pkgs.yabai;
    extraConfig = ''
      yabai -m config window_placement             first_child
      yabai -m config window_topmost               off
      yabai -m config window_opacity               off
      yabai -m config window_opacity_duration      0.0
      yabai -m config window_shadow                on
      yabai -m config window_border                off
      yabai -m config window_border_width          4
      yabai -m config active_window_border_color   0xff775759
      yabai -m config normal_window_border_color   0xff505050
      yabai -m config active_window_opacity        1.0
      yabai -m config normal_window_opacity        0.90
      yabai -m config split_ratio                  0.50
      yabai -m config auto_balance                 off
      yabai -m config mouse_modifier               fn
      yabai -m config mouse_action1                move
      yabai -m config mouse_action2                resize

      yabai -m config layout                       bsp
      yabai -m config top_padding                  10
      yabai -m config external_bar                 all:30:0
      yabai -m config bottom_padding               10
      yabai -m config left_padding                 20
      yabai -m config right_padding                20
      yabai -m config window_gap                   10

      yabai -m signal --add event=window_destroyed \
        action="''\'''${functions[focus_under_cursor]}"
      yabai -m signal --add event=window_minimized \
        action="''\'''${functions[focus_under_cursor]}"
      yabai -m signal --add event=application_hidden \
        action="''\'''${functions[focus_under_cursor]}"

      function focus_under_cursor {
        if yabai -m query --windows --space |
            jq -er 'map(select(.focused == 1)) | length == 0' >/dev/null; then
          yabai -m window --focus mouse 2>/dev/null || true
        fi
      }

      # Custom stuff
      ## Unmanaged apps
      # yabai -m rule --add app="/usr/local/bin/choose" manage=off
      # yabai -m rule --add app="/opt/homebrew/bin/choose" manage=off
      # yabai -m rule --add app="choose-launcher.sh" manage=off
      # yabai -m rule --add app="choose" manage=off
      # yabai -m rule --add app="/usr/local/bin/pinentry-mac" manage=off
      # yabai -m rule --add app="/opt/homebrew/bin/pinentry-mac" manage=off
      # yabai -m rule --add app="pinentry-mac" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      # yabai -m rule --add app="/Applications/Secretive.app/Contents/MacOS/Secretive" manage=off
    '';
  };

  # services.spacebar = {
  #   enable = true;
  #   package = pkgs.spacebar;
  #   config = {
  #     position                   = "bottom";
  #     display                    = "main";
  #     height                     = 26;
  #     title                      = "on";
  #     spaces                     = "on";
  #     clock                      = "on";
  #     power                      = "on";
  #     padding_left               = 20;
  #     padding_right              = 20;
  #     spacing_left               = 25;
  #     spacing_right              = 25;
  #     text_font                  = ''"Liga SFMono Nerd Font:Medium:13.0"'';
  #     icon_font                  = ''"Liga SFMono Nerd Font:Light:13.0"'';
  #     background_color           = "0xff2E3440";
  #     foreground_color           = "0xffD8DEE9";
  #     space_icon_color           = "0xff8fBcBB";
  #     power_icon_color           = "0xffEBCBDB";
  #     battery_icon_color         = "0xffA3BE8C";
  #     dnd_icon_color             = "0xffA3Be8C";
  #     clock_icon_color           = "0xff81a1C1";
  #     power_icon_strip           = " ";
  #     space_icon                 = "•";
  #     space_icon_strip           = "I II III IV V VI VII VIII IX X";
  #     spaces_for_all_displays    = "on";
  #     display_separator          = "on";
  #     display_separator_icon     = "";
  #     clock_icon                 = "";
  #     dnd_icon                   = "";
  #     clock_format               = ''"%d/%m/%y %R"'';
  #     right_shell                = "on";
  #     right_shell_icon           = "";
  #     right_shell_command        = "whoami";
  #   };
  # };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # focus workspace
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5
      cmd - 6 : yabai -m space --focus 6
      cmd - 7 : yabai -m space --focus 7
      cmd - 8 : yabai -m space --focus 8
      cmd - 9 : yabai -m space --focus 9
      cmd - 0 : yabai -m space --focus 10

      # move window to workspace
      shift + cmd - 1 : yabai -m window --space  1; yabai -m space --focus 1
      shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
      shift + cmd - 3 : yabai -m window --space  3; yabai -m space --focus 3
      shift + cmd - 4 : yabai -m window --space  4; yabai -m space --focus 4
      shift + cmd - 5 : yabai -m window --space  5; yabai -m space --focus 5
      shift + cmd - 6 : yabai -m window --space  6; yabai -m space --focus 6
      shift + cmd - 7 : yabai -m window --space  7; yabai -m space --focus 7
      shift + cmd - 8 : yabai -m window --space  8; yabai -m space --focus 8
      shift + cmd - 9 : yabai -m window --space  9; yabai -m space --focus 9
      shift + cmd - 0 : yabai -m window --space 10; yabai -m space --focus 10

      # focus window
      cmd - j : yabai -m window --focus west
      cmd - k : yabai -m window --focus south
      cmd - i : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      # swap window
      shift + cmd - j : yabai -m window --swap west
      shift + cmd - k : yabai -m window --swap south
      shift + cmd - i : yabai -m window --swap north
      shift + cmd - l : yabai -m window --swap east

    	# Fill space with window
    	ctrl + alt - 0 : yabai -m window --grid 1:1:0:0:1:1

    	# Close current window
    	shift + cmd - q : $(yabai -m window $(yabai -m query --windows --window | jq -re ".id") --close)

    	# Rotate tree
    	ctrl + alt - r : yabai -m space --rotate 90

    	# Open application
    	cmd - enter : kitty
    '';
  };
}
