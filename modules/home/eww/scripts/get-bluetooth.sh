#!/usr/bin/env bash

# bluetoothctlを使ってBluetooth状態を確認 (Overskride下でも同じコマンドが使用可能)
if bluetoothctl show | grep -q "Powered: yes"; then
  # 接続デバイスがあるか確認
  if bluetoothctl devices Connected | grep -q "Device"; then
    echo "connected"
  else
    echo "on"
  fi
else
  echo "off"
fi