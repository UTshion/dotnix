{ pkgs }:

pkgs.writeShellScriptBin "wallpaper-random" ''
  #!${pkgs.bash}/bin/bash
  
  # 壁紙ディレクトリの設定
  WALLPAPER_DIR="$HOME/Pictures/wallpapers"
  
  # ディレクトリの存在確認
  if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "エラー: 壁紙ディレクトリ '$WALLPAPER_DIR' が見つかりません"
    ${pkgs.libnotify}/bin/notify-send "壁紙変更エラー" "壁紙ディレクトリが見つかりません"
    exit 1
  fi
  
  # ランダムに壁紙を選択
  RANDOM_WALLPAPER=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o -iname "*.webp" \) | ${pkgs.coreutils}/bin/shuf -n 1)
  
  if [ -z "$RANDOM_WALLPAPER" ]; then
    echo "エラー: '$WALLPAPER_DIR' に画像ファイルが見つかりません"
    ${pkgs.libnotify}/bin/notify-send "壁紙変更エラー" "画像ファイルが見つかりません"
    exit 1
  fi
  
  echo "ランダム選択された壁紙: $RANDOM_WALLPAPER"
  
  # wallpaper-changerスクリプトを使用して壁紙を変更
  wallpaper-changer "$RANDOM_WALLPAPER"
''
