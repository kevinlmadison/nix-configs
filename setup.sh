#!/usr/bin/env bash

setup_config_dir() {
  local pwd=$(pwd)
  local host=$(hostname)

  # Move raw configs from platform to .config dir
  for dir in $(ls "$pwd"/hosts/"$host"/configs);
  do

    dir_link=~/.config/"$dir"
    dir_path="$pwd"/hosts/"$host"/configs/"$dir"

    # If we're in a fresh state, create a backup
    if [[   -d "$dir_link" &&
          ! -L "$dir_link" &&
          ! -d "$dir_link".bak
    ]]; then

      mv "$dir_link" "$dir_link".bak

    # If a symlink exists already, remove it
    elif [[ -d "$dir_link" &&
            -L "$dir_link"
    ]]; then

      rm -rf "$dir_link"

    fi

    # Create a symlink to the config dir in git
    ln -s "$dir_path" "$dir_link"

  done
}

setup_config_dir
