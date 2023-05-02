#!/usr/bin/bash
while true
do
    PIC=$(find -L ~/Pictures/Wallpapers/img/ -type f | shuf -n 1)
    swww img --transition-type wipe --transition-angle 30 --transition-step 90 "$PIC"
    sleep 5m
done
