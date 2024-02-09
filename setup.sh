#!/usr/bin/env bash

# Usage: ./setup.sh <hostname>

setup() {
  local user=$(whoami)
  local host=$(hostname)

  # Move raw configs from platform to .config dir
  for dir in $(ls ./hosts/"$host"/configs);
  do

    dir_link=/home/"$user"/.config/"$dir"
    dir_path=./hosts/"$host"/configs/"$dir"

    if [[ ! -d "$dir_link" ]]; then

      ln -s "$dir_path" "$dir_link"

    elif [[ -L "$dir_link" ]]; then

      rm -rf "$dir_link"
      ln -s "$dir_path" "$dir_link"

    else

      mv "$dir_link" "$dir_link".bak
      ln -s "$dir_path" "$dir_link"

    fi

  done
}

setup
