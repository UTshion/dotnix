#!/usr/bin/env bash

# システムメニューを開く（rofiを使用）
options="Shutdown\nReboot\nLogout\nSleep\nAudio Settings\nBluetooth\nCancel"
selected=$(echo -e "$options" | rofi -dmenu -i -p "System" -theme-str 'window {width: 300px;}')

case $selected in
  Shutdown)
    systemctl poweroff
    ;;
  Reboot)
    systemctl reboot
    ;;
  Logout)
    hyprctl dispatch exit
    ;;
  Sleep)
    systemctl suspend
    ;;
  "Audio Settings")
    pavucontrol &  # Pipewireでも使用可能
    ;;
  Bluetooth)
    overskride &
    ;;
  *)
    # キャンセルまたは他の選択の場合は何もしない
    ;;
esac