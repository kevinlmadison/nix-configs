#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &

# setting wallpaper
swww img ~/Wallpapers/Aurora.jpg &

nm-applet --indicator &

waybar &

dunst &