#!/usr/bin/env bash

swww init &
swww img ~/dotfiles/wallpapers/quantum-moon.png &
#nm-applet --indicator &
waybar &
dunst &
kdeconnect-indicator &
antimicrox --tray &
hypridle &
lxqt-policykit-agent

#much of this should be moved to services in .nix files
