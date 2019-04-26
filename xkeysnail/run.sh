#!/usr/bin/env bash

xhost +SI:localuser:xkeysnail
sudo DISPLAY=$DISPLAY /usr/bin/xkeysnail /home/ress/.config/xkeysnail/config.py
