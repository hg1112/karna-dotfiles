#!/usr/bin/env bash
# Called by udev on display connect/disconnect.
sleep 2  # let xrandr settle after hotplug

USER_NAME=$(who | awk '/\(:0\)/{print $1; exit}')
[ -z "$USER_NAME" ] && exit 0

USER_ID=$(id -u "$USER_NAME")
XAUTH="/run/user/${USER_ID}/Xauthority"
[ ! -f "$XAUTH" ] && XAUTH="/home/${USER_NAME}/.Xauthority"

su "$USER_NAME" -c "DISPLAY=:0 XAUTHORITY=$XAUTH autorandr --change"
