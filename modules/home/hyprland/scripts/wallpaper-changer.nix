{ pkgs }:

pkgs.writeShellScriptBin "wallpaper-changer" ''
  #!${pkgs.bash}/bin/bash
  
  # 壁紙を実際に適用する関数
  apply_wallpaper() {
    local WALLPAPER_PATH="$1"
    local APPLY_PYWAL="$2"  # true/false
    
    # ファイルの存在確認
    if [ ! -f "$WALLPAPER_PATH" ]; then
      echo "エラー: ファイル '$WALLPAPER_PATH' が見つかりません"
      notify-send "壁紙変更エラー" "ファイルが見つかりません: $WALLPAPER_PATH"
      return 1
    fi
    
    # 絶対パスに変換
    local WALLPAPER_ABSOLUTE=$(realpath "$WALLPAPER_PATH")
    
    echo "壁紙を変更しています: $WALLPAPER_ABSOLUTE"
    
    # Hyprpaperに新しい壁紙をプリロード
    hyprctl hyprpaper preload "$WALLPAPER_ABSOLUTE"
    
    # 全モニターに壁紙を設定
    for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
      echo "モニター '$monitor' に壁紙を設定中..."
      hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER_ABSOLUTE"
    done
    
    # pywalの適用（フラグがtrueの場合のみ）
    if [ "$APPLY_PYWAL" = "true" ]; then
      echo "カラースキーマを生成しています..."
      wal -i "$WALLPAPER_ABSOLUTE" -n
      
      if [ $? -eq 0 ]; then
        echo "カラースキーマが正常に適用されました"
        
        # Starshipの設定をpywalカラーに更新 (無効化: NixOS設定を使用)
        # if command -v update-starship-pywal >/dev/null 2>&1; then
        #   echo "Starshipにpywalカラーを適用中..."
        #   update-starship-pywal pywal
        # fi
        echo "Starship設定は変更せず、NixOS設定を使用します"
        
        notify-send "壁紙変更完了" "壁紙とカラースキーマが更新されました"
        
        # 現在使用中の壁紙をシンボリックリンクとして保存
        ln -sf "$WALLPAPER_ABSOLUTE" "$HOME/Pictures/current-wallpaper"
        
        # pywalで生成されたカラースキーマをHyprlandに反映
        hyprctl reload
      else
        echo "エラー: カラースキーマの生成に失敗しました"
        notify-send "カラースキーマエラー" "カラースキーマの生成に失敗しました"
        return 1
      fi
    else
      notify-send "壁紙変更完了" "壁紙が更新されました（プレビューモード）"
    fi
    
    return 0
  }
  
  # 引数の解析
  case "$1" in
    "--help"|"-h")
      echo "使用方法:"
      echo "  wallpaper-changer                    # GUIで壁紙を選択"
      echo "  wallpaper-changer <ファイルパス>      # CLIで直接指定（pywal適用）"
      echo "  wallpaper-changer --preview <ファイル> # CLIでプレビューのみ"
      echo "  wallpaper-changer --gruvbox          # gruvboxテーマに戻す"
      echo "  wallpaper-changer --help            # このヘルプを表示"
      exit 0
      ;;
    "--preview")
      if [ -z "$2" ]; then
        echo "エラー: プレビュー対象のファイルパスを指定してください"
        exit 1
      fi
      apply_wallpaper "$2" "false"
      exit $?
      ;;
    "--gruvbox")
      echo "gruvboxテーマオプション (無効化: NixOS設定を使用)"
      # if command -v update-starship-pywal >/dev/null 2>&1; then
      #   update-starship-pywal gruvbox
      #   notify-send "テーマ変更" "gruvboxテーマに戻しました"
      # fi
      notify-send "テーマ情報" "Starship設定はNixOSで管理されています"
      exit 0
      ;;
    "")
      # 引数なし：GUIモード
      # zenityで壁紙を選択
      WALLPAPER_PATH=$(zenity --file-selection \
        --title="壁紙を選択してください" \
        --file-filter="画像ファイル | *.jpg *.jpeg *.png *.bmp *.webp *.gif" \
        --file-filter="すべてのファイル | *" 2>/dev/null)
      
      if [ $? -ne 0 ] || [ -z "$WALLPAPER_PATH" ]; then
        echo "壁紙選択がキャンセルされました"
        notify-send "壁紙変更" "選択がキャンセルされました"
        exit 0
      fi
      
      apply_wallpaper "$WALLPAPER_PATH" "true"
      exit 0
      ;;
    *)
      # CLIモード：直接ファイルパスが指定された場合
      apply_wallpaper "$1" "true"
      exit $?
      ;;
  esac
''
