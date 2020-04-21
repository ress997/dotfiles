#!/usr/bin/env bash
# eDP1: ノートディスプレイ
# HDMI2: HDML ポート

if [ $(cat /sys/class/drm/card0-HDMI-A-2/status) = "connected" ]; then
	xrandr --output eDP1 --auto --output HDMI2 --auto --above eDP1
else
	xrandr --output eDP1 --auto --output HDMI2 --off
fi
