#!/usr/bin/env bash

# Pipewire/パルスオーディオエミュレーションを使用して音量を取得
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)' | head -1)

# ミュート状態の確認
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false")

if [ "$muted" = "true" ]; then
  echo "0"
else
  echo "$volume"
fi