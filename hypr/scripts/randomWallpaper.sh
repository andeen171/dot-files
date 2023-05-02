#!/usr/bin/bash
while true
do
    PIC=$(find -L ~/Pictures/Wallpapers/img/ -type f | shuf -n 1)
    swww img "$PIC"
    sleep 5m
done
