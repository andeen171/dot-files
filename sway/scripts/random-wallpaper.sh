#!/bin/sh
while true
do
    PIC=$(find -L ~/Pictures/Wallpapers -type f | shuf -n 1)
    swaymsg output "*" bg "$PIC" fill
    sleep 10m
done
