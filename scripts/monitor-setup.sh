#!/usr/bin/env bash
# Configures monitors based on what's connected.
# HDMI connected  → laptop (eDP) primary left, HDMI secondary right
# HDMI absent     → laptop only

INTERNAL="eDP"
EXTERNAL="HDMI-A-0"

hdmi_connected() {
    xrandr --query | grep -E "^${EXTERNAL} connected" > /dev/null
}

if hdmi_connected; then
    xrandr \
        --output "$INTERNAL" --primary --mode 1920x1080 --rate 120 --pos 0x0 \
        --output "$EXTERNAL" --mode 2560x1440 --rate 144 --pos 1920x0
else
    xrandr \
        --output "$INTERNAL" --primary --mode 1920x1080 --rate 120 --pos 0x0 \
        --output "$EXTERNAL" --off
fi
