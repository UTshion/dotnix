# modules/home/eww/scripts/bluetooth.nix
{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScriptBin "get-bluetooth" ''
    # bluetoothctlを使ってBluetooth状態を確認
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
  '';
in
{
  home.packages = [ script ];
  
  home.file.".config/eww/scripts/get-bluetooth".source = "${script}/bin/get-bluetooth";
}
