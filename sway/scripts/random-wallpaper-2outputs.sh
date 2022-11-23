#!/bin/sh
while true
do
    PIC=$(find ~/Pictures/Wallpapers -type f | shuf -n 1)
    swaymsg output "HDMI-A-1" bg "$PIC" fill
    PIC=$(find ~/Pictures/Wallpapers -type f | shuf -n 1)
    swaymsg output "DP-1" bg "$PIC" fill
    sleep 10m
done
