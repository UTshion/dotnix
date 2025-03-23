# modules/home/eww/scripts/volume.nix
{ config, pkgs, lib, ... }:

let
  getVolume = pkgs.writeShellScriptBin "get-volume" ''
    # Pipewire/パルスオーディオエミュレーションを使用して音量を取得
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '[0-9]+(?=%)' | head -1)
    
    # ミュート状態の確認
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false")
    
    if [ "$muted" = "true" ]; then
      echo "0"
    else
      echo "$volume"
    fi
  '';
  
  setVolume = pkgs.writeShellScriptBin "set-volume" ''
    # 引数からボリュームを取得
    VOLUME=$1
    
    # Pipewireの音量を設定
    pactl set-sink-volume @DEFAULT_SINK@ "''${VOLUME}%"
  '';
  
  toggleMute = pkgs.writeShellScriptBin "toggle-mute" ''
    # ミュート状態を切り替え
    pactl set-sink-mute @DEFAULT_SINK@ toggle
  '';
in
{
  home.packages = [ getVolume setVolume toggleMute ];
  
  home.file = {
    ".config/eww/scripts/get-volume".source = "${getVolume}/bin/get-volume";
    ".config/eww/scripts/set-volume".source = "${setVolume}/bin/set-volume";
    ".config/eww/scripts/toggle-mute".source = "${toggleMute}/bin/toggle-mute";
  };
}
