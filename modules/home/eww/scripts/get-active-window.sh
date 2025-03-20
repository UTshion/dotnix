#!/usr/bin/env bash

# Hyprlandからアクティブウィンドウの情報を取得
window_info=$(hyprctl activewindow -j)

# jqを使用してウィンドウタイトルを抽出
if [[ $window_info == *"title"* ]]; then
  window_title=$(echo "$window_info" | jq -r '.title')
  window_class=$(echo "$window_info" | jq -r '.class')
  
  # タイトルが長すぎる場合は切り詰める
  if [ ${#window_title} -gt 50 ]; then
    window_title="${window_title:0:47}..."
  fi
  
  echo "$window_class: $window_title"
else
  echo "Desktop"
fi