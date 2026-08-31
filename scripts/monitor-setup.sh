#!/usr/bin/env bash
choice=$(autorandr --list | rofi -dmenu -p "Monitor layout" -theme-str 'window {width: 400px;}')
[ -n "$choice" ] && autorandr --load "$choice"
