# modules/home/eww/scripts/system-tray.nix
{ config, pkgs, lib, ... }:

let
  getSystemTray = pkgs.writeShellScriptBin "get-system-tray" ''
    # バックグラウンドプロセスの検出（例：sunshine, steam, discord等）
    tray_items=()
    
    # Sunshine（ストリーミングサーバー）
    if pgrep -x "sunshine" > /dev/null; then
      tray_items+=("sunshine:Sunshine:󰢹")
    fi
    
    # Steam
    if pgrep -x "steam" > /dev/null; then
      tray_items+=("steam:Steam:")
    fi
    
    # Discord
    if pgrep -x "Discord" > /dev/null || pgrep -x "discord" > /dev/null; then
      tray_items+=("discord:Discord:󰙯")
    fi
    
    # SpotifyやWebブラウザなど、他のバックグラウンドプロセスもチェック可能
    if pgrep -x "spotify" > /dev/null || pgrep -x "Spotify" > /dev/null; then
      tray_items+=("spotify:Spotify:")
    fi
    
    # JSON形式で出力（ewwで解析しやすいように）
    echo "["
    for i in "''${!tray_items[@]}"; do
      IFS=':' read -r id name icon <<< "''${tray_items[$i]}"
      echo "  {"
      echo "    \"id\": \"$id\","
      echo "    \"name\": \"$name\","
      echo "    \"icon\": \"$icon\""
      echo "  }"
      # 最後の項目でなければカンマを追加
      if [ $i -lt $((''${#tray_items[@]} - 1)) ]; then
        echo "  ,"
      fi
    done
    echo "]"
  '';
  
  openAppMenu = pkgs.writeShellScriptBin "open-app-menu" ''
    # アプリ固有のメニューを開く
    app_id=$1
    
    case "$app_id" in
      "sunshine")
        xdg-open http://localhost:47990/ &
        ;;
      "steam")
        # Steamが最小化されていれば復元、起動していなければ起動
        if pgrep -x "steam" > /dev/null; then
          hyprctl dispatch focuswindow "class:^(Steam)$"
        else
          steam &
        fi
        ;;
      "discord")
        # Discordを再表示または起動
        if pgrep -x "discord" > /dev/null || pgrep -x "Discord" > /dev/null; then
          hyprctl dispatch focuswindow "class:^(discord)$"
        else
          discord &
        fi
        ;;
      "spotify")
        # Spotifyを再表示または起動
        if pgrep -x "spotify" > /dev/null || pgrep -x "Spotify" > /dev/null; then
          hyprctl dispatch focuswindow "class:^(Spotify)$"
        else
          spotify &
        fi
        ;;
      *)
        notify-send "App Menu" "No action defined for $app_id"
        ;;
    esac
  '';
in
{
  home.packages = [ getSystemTray openAppMenu ];
  
  home.file = {
    ".config/eww/scripts/get-system-tray".source = "${getSystemTray}/bin/get-system-tray";
    ".config/eww/scripts/open-app-menu".source = "${openAppMenu}/bin/open-app-menu";
  };
}
