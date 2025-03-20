#!/usr/bin/env bash

# 引数からボリュームを取得
VOLUME=$1

# Pipewireの音量を設定
pactl set-sink-volume @DEFAULT_SINK@ ${VOLUME}%