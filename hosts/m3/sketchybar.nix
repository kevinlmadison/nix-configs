{
  config,
  pkgs,
  ...
}: let
  # Kanagawa Dragon colors
  kanagawa = {
    bg = "0x0d0d0c28"; # sumiInk1
    bg_alt = "0x18161637"; # sumiInk2
    fg = "0xffdcd7ba"; # fujiWhite
    orange = "0xffffa066"; # surimiOrange
    cyan = "0x8ea4a2ca"; # waveAqua1
    # cyan = "0xff7fb4ca"; # waveAqua1
    pink = "0xffd27e99"; # peachRed
    green = "0xff98bb6c"; # springGreen
  };

  # Updated shell scripts with new colors
  space-sh = pkgs.writeShellScriptBin "space.sh" ''
    if [ "$SELECTED" = "true" ]
    then
      sketchybar -m --set $NAME background.color=${kanagawa.cyan}
      sketchybar -m --set $NAME icon.color=${kanagawa.orange}
    else
      sketchybar -m --set $NAME background.color=${kanagawa.bg_alt}
      sketchybar -m --set $NAME icon.color=${kanagawa.cyan}
    fi
  '';

  space-click-sh = pkgs.writeShellScriptBin "space-click.sh" ''
    yabai -m space --focus $SID 2>/dev/null
  '';
  window-title-sh = pkgs.writeShellScriptBin "window_title.sh" ''
    WINDOW_TITLE=$(yabai -m query --windows --window | ${pkgs.jq}/bin/jq -r '.app')
    if [[ $WINDOW_TITLE != "" ]]; then
      sketchybar -m --set title label="$WINDOW_TITLE"
    else
      sketchybar -m --set title label=None
    fi
  '';
  date-time-sh = pkgs.writeShellScriptBin "date-time.sh" ''
    sketchybar -m --set $NAME label="$(date '+%a %d %b %H:%M')"
  '';
  top-mem-sh = pkgs.writeShellScriptBin "top-mem.sh" ''
    TOPPROC=$(ps axo "%cpu,ucomm" | sort -nr | tail +1 | head -n1 | awk '{printf "%.0f%% %s\n", $1, $2}' | sed -e 's/com.apple.//g')
    TOPMEM=$(ps axo "rss" | sort -nr | tail +1 | head -n1 | awk '{printf "%.0fMB %s\n", $1 / 1024, $2}' | sed -e 's/com.apple.//g')
    MEM=$(echo $TOPMEM | sed -nr 's/([^MB]+).*/\1/p')
    sketchybar -m --set $NAME label="$TOPMEM"
  '';
  cpu-sh = pkgs.writeShellScriptBin "cpu.sh" ''
    CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
    CPU_INFO=$(ps -eo pcpu,user)
    CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
    CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
    sketchybar -m --set  cpu_percent label=$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')%
  '';
  caffeine-sh = pkgs.writeShellScriptBin "caffeine.sh" ''
    if pgrep -q 'caffeinate'
    then
      sketchybar --set $NAME icon="󰅶"
    else
      sketchybar --set $NAME icon="󰛊"
    fi
  '';
  caffeine-click-sh = pkgs.writeShellScriptBin "caffeine-click.sh" ''
    if pgrep -q 'caffeinate'
    then
      killall caffeinate
      sketchybar --set $NAME icon="󰛊"
    else
      caffeinate -d & disown
      sketchybar --set $NAME icon="󰅶"
    fi
  '';

  battery-sh = pkgs.writeShellScriptBin "battery.sh" ''
    data=$(pmset -g batt)
    battery_percent=$(echo $data | grep -Eo "\d+%" | cut -d% -f1)
    charging=$(echo $data | grep 'AC Power')

    case "$battery_percent" in
        100)    icon="󰁹" color=${kanagawa.orange} ;;
        9[0-9]) icon="󰂂" color=${kanagawa.orange} ;;
        8[0-9]) icon="󰂁" color=${kanagawa.orange} ;;
        7[0-9]) icon="󰂀" color=${kanagawa.orange} ;;
        6[0-9]) icon="󰁿" color=${kanagawa.orange} ;;
        5[0-9]) icon="󰁾" color=${kanagawa.orange} ;;
        4[0-9]) icon="󰁽" color=${kanagawa.orange} ;;
        3[0-9]) icon="󰁼" color=${kanagawa.orange} ;;
        2[0-9]) icon="󰁻" color=${kanagawa.orange} ;;
        1[0-9]) icon="󰁺" color=${kanagawa.orange} ;;
        *)      icon="󰂃" color=${kanagawa.orange} ;;
    esac

    if ! [ -z "$charging" ]; then
        icon="$icon"
    fi

    sketchybar \
        --set $NAME \
            icon.color="$color" \
            icon="$icon" \
            label="$battery_percent%"
  '';
  # Other scripts remain unchanged unless needed
  top-proc-sh = pkgs.writeShellScriptBin "top-proc.sh" ''
    TOPPROC=$(ps axo "%cpu,ucomm" | sort -nr | tail +1 | head -n1 | awk '{printf "%.0f%% %s\n", $1, $2}' | sed -e 's/com.apple.//g')
    CPUP=$(echo $TOPPROC | sed -nr 's/([^\%]+).*/\1/p')
    if [ $CPUP -gt 75 ]; then
      sketchybar -m --set $NAME label="$TOPPROC"
    else
      sketchybar -m --set $NAME label=""
    fi
  '';
  spotify-indicator-sh = pkgs.writeShellScriptBin "spotify-indicator.sh" ''
    RUNNING="$(osascript -e 'if application "Spotify" is running then return 0')"
    if [ $RUNNING != 0 ]
    then
      RUNNING=1
    fi
    PLAYING=1
    TRACK=""
    ALBUM=""
    ARTIST=""
    if [[ $RUNNING -eq 0 ]]
    then
      [[ "$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to get player state')" == "playing" ]] && PLAYING=0
      TRACK="$(osascript -e 'tell application "Spotify" to get name of current track')"
      ARTIST="$(osascript -e 'tell application "Spotify" to get artist of current track')"
      ALBUM="$(osascript -e 'tell application "Spotify" to get album of current track')"
    fi
    if [[ -n "$TRACK" ]]
    then
      sketchybar -m --set "$NAME" drawing=on
      [[ "$PLAYING" -eq 0 ]] && ICON=""
      [[ "$PLAYING" -eq 1 ]] && ICON=""
      if [ "$ARTIST" == "" ]
      then
        sketchybar -m --set "$NAME" label="''${ICON} ''${TRACK} - ''${ALBUM}"
      else
        sketchybar -m --set "$NAME" label="''${ICON} ''${TRACK} - ''${ARTIST}"
      fi
    else
      sketchybar -m --set "$NAME" label="" drawing=off
    fi
  '';
in {
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.gohufont
      nerd-fonts.hack
      dpkg
    ];
    config = ''
      #!/usr/bin/env bash

      ############## BAR ##############
      sketchybar -m --bar \
        height=32 \
        position=top \
        padding_left=5 \
        padding_right=5 \
        color=${kanagawa.bg} \
        shadow=off \
        sticky=on \
        topmost=off

      ############## GLOBAL DEFAULTS ##############
      sketchybar -m --default \
        updates=when_shown \
        drawing=on \
        cache_scripts=on \
        icon.font="JetBrainsMono Nerd Font Mono:Bold:18.0" \
        icon.color=${kanagawa.orange} \
        icon.highlight_color=${kanagawa.pink} \
        label.font.family="GohuFont 14 Nerd Font" \
        label.font.style="Bold" \
        label.font.size=12.0 \
        label.color=${kanagawa.fg} \
        label.highlight_color=${kanagawa.cyan} \
        background.highlight_color=${kanagawa.bg_alt}

      ############## SPACE DEFAULTS ##############
      sketchybar -m --default \
        label.padding_left=5 \
        label.padding_right=2 \
        icon.padding_left=8 \
        label.padding_right=8

      ############## PRIMARY DISPLAY SPACES ##############
      sketchybar -m --add item apple left \
        --set apple icon= \
        --set apple icon.font="JetBrainsMono Nerd Font Mono:Regular:20.0" \
        --set apple label.padding_right=0 \
        --set apple icon.color=${kanagawa.cyan}

      for s in "1" "2" "3" "4" "5" "6" "7" "8" "9" "0";
      do
        sketchybar -m --add space "$s" left \
          --set "$s" icon="$s" \
          --set "$s" associated_space="$s" \
          --set "$s" icon.padding_left=5 \
          --set "$s" icon.padding_right=5 \
          --set "$s" icon.font="Hack Nerd Font:Regular:14.0" \
          --set "$s" icon.color=${kanagawa.cyan} \
          --set "$s" label.padding_right=0 \
          --set "$s" label.padding_left=0 \
          --set "$s" label.color=${kanagawa.pink} \
          --set "$s" background.color=${kanagawa.bg_alt} \
          --set "$s" background.height=19 \
          --set "$s" background.padding_left=7 \
          --set "$s" script="${space-sh}/bin/space.sh" \
          --set "$s" click_script="${space-click-sh}/bin/space-click.sh"
      done

      ############## RIGHT ITEMS ##############
      sketchybar -m --add item date_time right \
        --set date_time icon= \
        --set date_time icon.padding_left=8 \
        --set date_time icon.padding_right=0 \
        --set date_time label.padding_right=9 \
        --set date_time label.padding_left=6 \
        --set date_time label.color=${kanagawa.fg} \
        --set date_time update_freq=20 \
        --set date_time background.color=${kanagawa.bg_alt} \
        --set date_time background.height=19 \
        --set date_time background.padding_right=12 \
        --set date_time script="${date-time-sh}/bin/date-time.sh"

      sketchybar -m --add item battery right \
        --set battery icon.font="JetBrainsMono Nerd Font Mono:Bold:10.0" \
        --set battery icon.padding_left=8 \
        --set battery icon.padding_right=8 \
        --set battery label.padding_right=8 \
        --set battery label.padding_left=0 \
        --set battery label.color=${kanagawa.fg} \
        --set battery background.color=${kanagawa.bg_alt} \
        --set battery background.height=19 \
        --set battery background.padding_right=7 \
        --set battery update_freq=10 \
        --set battery script="${battery-sh}/bin/battery.sh"

      sketchybar -m --add item topmem right \
        --set topmem icon= \
        --set topmem icon.padding_left=8 \
        --set topmem icon.padding_right=0 \
        --set topmem label.padding_right=8 \
        --set topmem label.padding_left=6 \
        --set topmem label.color=${kanagawa.fg} \
        --set topmem background.color=${kanagawa.bg_alt} \
        --set topmem background.height=19 \
        --set topmem background.padding_right=7 \
        --set topmem update_freq=2 \
        --set topmem script="${top-mem-sh}/bin/top-mem.sh"

      sketchybar -m --add item cpu_percent right \
        --set cpu_percent icon= \
        --set cpu_percent icon.padding_left=8 \
        --set cpu_percent icon.padding_right=0 \
        --set cpu_percent label.padding_right=8 \
        --set cpu_percent label.padding_left=6 \
        --set cpu_percent label.color=${kanagawa.fg} \
        --set cpu_percent background.color=${kanagawa.bg_alt} \
        --set cpu_percent background.height=19 \
        --set cpu_percent background.padding_right=7 \
        --set cpu_percent update_freq=2 \
        --set cpu_percent script="${cpu-sh}/bin/cpu.sh"

      sketchybar -m --add item caffeine right \
        --set caffeine icon.padding_left=8 \
        --set caffeine icon.padding_right=0 \
        --set caffeine label.padding_right=0 \
        --set caffeine label.padding_left=6 \
        --set caffeine label.color=${kanagawa.fg} \
        --set caffeine background.color=${kanagawa.bg_alt} \
        --set caffeine background.height=19 \
        --set caffeine background.padding_right=7 \
        --set caffeine script="${caffeine-sh}/bin/caffeine.sh" \
        --set caffeine click_script="${caffeine-click-sh}/bin/caffeine-click.sh"

      sketchybar -m --add item topproc right \
        --set topproc drawing=on \
        --set topproc label.padding_right=10 \
        --set topproc update_freq=15 \
        --set topproc script="${top-proc-sh}/bin/topproc.sh"

      sketchybar -m --update
      echo "sketchybar configuration loaded.."
    '';
  };
}
