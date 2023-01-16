#!/bin/sh

# also set cursor size in wrapper file (for me it's /usr/local/bin/hyprland-wrapper.sh)

theme="Catppuccin-Mocha-Dark-Cursors"

size=24

hyprctl setcursor $theme $size
hyprctl dispatch -- exec gsettings set org.gnome.desktop.interface cursor-theme $theme
hyprctl dispatch -- exec gsettings set org.gnome.desktop.interface cursor-size $size

# give flatpak permission to read from the .icons folder, and set the cursor path
flatpak override --user --env=XCURSOR_PATH=~/.icons
flatpak override --user --filesystem=/home/"$USER"/.icons/:ro
