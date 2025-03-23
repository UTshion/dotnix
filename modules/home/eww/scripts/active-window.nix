# modules/home/eww/scripts/active-window.nix
{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScriptBin "get-active-window" ''
    # Hyprlandからアクティブウィンドウの情報を取得
    window_info=$(hyprctl activewindow -j)

    # jqを使用してウィンドウタイトルとクラスを抽出
    if [[ $window_info == *"title"* ]]; then
      window_title=$(echo "$window_info" | jq -r '.title')
      window_class=$(echo "$window_info" | jq -r '.class')
      
      # タイトルが長すぎる場合は切り詰める
      if [ ''${#window_title} -gt 50 ]; then
        window_title="''${window_title:0:47}..."
      fi
      
      # アイコンを取得（アプリケーションによって異なる）
      icon_name=""
      case "$window_class" in
        "firefox")
          icon_name="" # Nerd FontのFirefoxアイコン
          ;;
        "Alacritty"|"kitty"|"termite")
          icon_name="" # ターミナルアイコン
          ;;
        "code-oss"|"VSCodium"|"Code")
          icon_name="" # VSCodeアイコン
          ;;
        "discord")
          icon_name="󰙯" # Discordアイコン
          ;;
        "Spotify")
          icon_name="" # Spotifyアイコン
          ;;
        *)
          icon_name="" # デフォルトアイコン
          ;;
      esac
      
      # アイコンとタイトルを返す
      echo "$icon_name $window_class: $window_title"
    else
      echo " Desktop"
    fi
  '';
in
{
  home.packages = [ script ];
  
  home.file.".config/eww/scripts/get-active-window".source = "${script}/bin/get-active-window";
}
