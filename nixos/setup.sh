#!/usr/bin/env bash

# Usage: ./setup.sh <hostname>

setup() {
  user=$(whoami)


  # Move raw configs from platform to .config dir
  for dir in $(ls ./hosts/"$1"/configs);
  do
    ln -s ./hosts/"$1"/configs/"$dir" /home/"$user"/.config/"$dir";
  done
}

setup
