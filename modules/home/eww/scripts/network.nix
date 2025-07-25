# modules/home/eww/scripts/network.nix
{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScriptBin "get-network" ''
    # NetworkManagerを使ってネットワーク状態を確認
    if nmcli g | grep -q "connected"; then
      # WiFiの場合は接続名を取得
      if nmcli -t -f DEVICE,TYPE,STATE device | grep -q "wifi:connected"; then
        ssid=$(nmcli -t -f SSID,SIGNAL dev wifi list | grep "^*" | awk -F ':' '{print $1}' | tr -d '*')
        echo "connected"
      # 有線の場合
      elif nmcli -t -f DEVICE,TYPE,STATE device | grep -q "ethernet:connected"; then
        echo "connected"
      else
        echo "connected"
      fi
    else
      echo "disconnected"
    fi
  '';
in
{
  home.packages = [ script ];
  
  home.file.".config/eww/scripts/get-network".source = "${script}/bin/get-network";
}
