#! /bin/bash

lockcmd="swaylockd --screenshots --clock --indicator-idle-visible --indicator-radius 100 --indicator-thickness 7 --ignore-empty-password --ring-color 53E2AE --ring-ver-color 53E2AE --ring-wrong-color EE4F84 --key-hl-color EE4F84 --text-color ffffff --text-ver-color ffffff --text-wrong-color EE4F84 --line-color 00000000 --inside-color 00000088 --inside-ver-color 00000088 --inside-wrong-color 00000088 --separator-color 00000000 --fade-in 0.15 --effect-blur 10x2"

bat=$(ls /sys/class/power_supply | grep -m 1 "BAT")

sway-audio-idle-inhibit & 
swayidle -w \
  timeout 1200 "$lockcmd & if [[ \"$(cat /sys/class/power_supply/"$bat"/status)\" == \"Discharging\" ]]; then systemctl suspend; else hyprctl dispatch dpms off; fi" resume "hyprctl dispatch dpms on"\
    before-sleep "$lockcmd"
