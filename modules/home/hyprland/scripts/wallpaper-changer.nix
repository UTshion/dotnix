{ pkgs }:

pkgs.writeShellScriptBin "wallpaper-changer" ''
  #!${pkgs.bash}/bin/bash
  
  # 引数チェック
  if [ $# -eq 0 ]; then
    echo "使用方法: wallpaper-changer <壁紙ファイルのパス>"
    echo "例: wallpaper-changer ~/Pictures/new-wallpaper.jpg"
    exit 1
  fi
  
  WALLPAPER_PATH="$1"
  
  # ファイルの存在確認
  if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "エラー: ファイル '$WALLPAPER_PATH' が見つかりません"
    ${pkgs.libnotify}/bin/notify-send "壁紙変更エラー" "ファイルが見つかりません: $WALLPAPER_PATH"
    exit 1
  fi
  
  # 絶対パスに変換
  WALLPAPER_ABSOLUTE=$(${pkgs.coreutils}/bin/realpath "$WALLPAPER_PATH")
  
  echo "壁紙を変更しています: $WALLPAPER_ABSOLUTE"
  
  # Hyprpaperに新しい壁紙をプリロード
  ${pkgs.hyprland}/bin/hyprctl hyprpaper preload "$WALLPAPER_ABSOLUTE"
  
  # 全モニターに壁紙を設定
  for monitor in $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name'); do
    echo "モニター '$monitor' に壁紙を設定中..."
    ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER_ABSOLUTE"
  done
  
  # pywalでカラースキーマを生成・適用
  echo "カラースキーマを生成しています..."
  wal -i "$WALLPAPER_ABSOLUTE" -n
  
  # カラースキーマが正常に生成されたか確認
  if [ $? -eq 0 ]; then
    echo "カラースキーマが正常に適用されました"
    ${pkgs.libnotify}/bin/notify-send "壁紙変更完了" "壁紙とカラースキーマが更新されました"
    
    # 現在使用中の壁紙をシンボリックリンクとして保存（オプション）
    ${pkgs.coreutils}/bin/ln -sf "$WALLPAPER_ABSOLUTE" "$HOME/Pictures/current-wallpaper"
    
    # pywalで生成されたカラースキーマをHyprlandに反映
    ${pkgs.hyprland}/bin/hyprctl reload
  else
    echo "エラー: カラースキーマの生成に失敗しました"
    ${pkgs.libnotify}/bin/notify-send "カラースキーマエラー" "カラースキーマの生成に失敗しました"
    exit 1
  fi
''
