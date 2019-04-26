#!/usr/bin/env bash

PICTURES_DIR=$(xdg-user-dir PICTURES)
SAVE_DIR="${PICTURES_DIR}/SS/$(date '+%Y-%m')"
SAVE_TIME="$(date '+%d-%H-%M-%S')"

mkdir -p "${SAVE_DIR}"
imlib2_grab "${SAVE_DIR}/${SAVE_TIME}.png"
