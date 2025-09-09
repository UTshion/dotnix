{ pkgs }:

let 
  ags-wallpaper-launcher = import ./ags-wallpaper-launcher.nix { inherit pkgs; };
in
pkgs.writeShellScriptBin "change-wallpaper" ''
  #!/usr/bin/env bash

  WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
  HYPR_CONFIG="$HOME/.config/hypr/hyprpaper.conf"
  STARSHIP_CONFIG="$HOME/.config/starship.toml"

  # デフォルト壁紙ディレクトリを作成
  mkdir -p "$WALLPAPER_DIR"

  apply_wallpaper() {
    local wallpaper_path="$1"
    
    if [ ! -f "$wallpaper_path" ]; then
      echo "Error: Wallpaper file not found: $wallpaper_path"
      return 1
    fi

    echo "Applying wallpaper: $wallpaper_path"

    # hyprpaperの設定を更新
    cat > "$HYPR_CONFIG" <<EOF
preload = $wallpaper_path
wallpaper = , $wallpaper_path
splash = false
ipc = on
EOF

    # hyprpaperを再起動
    pkill hyprpaper 2>/dev/null || true
    sleep 0.5
    ${pkgs.hyprpaper}/bin/hyprpaper &

    # pywalでカラースキーマを生成
    echo "Generating color scheme with pywal..."
    ${pkgs.pywal}/bin/wal -i "$wallpaper_path" -n

    # Hyprlandの設定を更新
    update_hyprland_colors

    # Starshipの設定を更新 (無効化: NixOS設定を使用)
    # update_starship_colors

    echo "Wallpaper and color scheme applied successfully!"
  }

  update_hyprland_colors() {
    local colors_file="$HOME/.cache/wal/colors.sh"
    
    if [ ! -f "$colors_file" ]; then
      echo "Warning: pywal colors file not found"
      return 1
    fi

    # pywalの色を読み込み
    source "$colors_file"

    # Hyprlandの色設定を動的に更新
    ${pkgs.hyprland}/bin/hyprctl keyword general:col.active_border "rgb(''${color1:1}) rgb(''${color2:1}) 45deg"
    ${pkgs.hyprland}/bin/hyprctl keyword general:col.inactive_border "rgb(''${color0:1})"
    ${pkgs.hyprland}/bin/hyprctl keyword decoration:col.shadow "rgba(''${color0:1}ee)"
  }

  # update_starship_colors() {
  #   # Starship色更新処理は無効化 (NixOS設定を使用)
  #   echo "Starship color update disabled - using NixOS configuration"
  # }

  main() {
    if command -v ags >/dev/null 2>&1; then
      echo "Starting AGS wallpaper selector..."
      ${ags-wallpaper-launcher}/bin/ags-wallpaper-launcher
    else
      zenity_fallback
    fi
  }

  zenity_fallback() {
    echo "AGS not available, falling back to Zenity..."
    
    # ディレクトリ選択オプション
    if [ "$1" = "--select-dir" ] || [ ! -d "$WALLPAPER_DIR" ] || [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
      SELECTED_DIR=$(${pkgs.zenity}/bin/zenity --file-selection --directory --title="壁紙ディレクトリを選択してください" --filename="$WALLPAPER_DIR/")
      if [ -n "$SELECTED_DIR" ]; then
        WALLPAPER_DIR="$SELECTED_DIR"
      fi
    fi

    # 壁紙ファイル選択
    WALLPAPER_FILES=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | sort))
    
    if [ ''${#WALLPAPER_FILES[@]} -eq 0 ]; then
      ${pkgs.zenity}/bin/zenity --error --text="壁紙ディレクトリに画像ファイルが見つかりません: $WALLPAPER_DIR"
      exit 1
    fi

    # ファイル選択ダイアログ
    SELECTED_WALLPAPER=$(printf '%s\n' "''${WALLPAPER_FILES[@]}" | ${pkgs.zenity}/bin/zenity --list --column="壁紙ファイル" --title="壁紙を選択してください" --height=400 --width=600)
    
    if [ -n "$SELECTED_WALLPAPER" ]; then
      apply_wallpaper "$SELECTED_WALLPAPER"
    fi
  }

  # メイン実行部分
  case "$1" in
    "--apply")
      if [ -n "$2" ]; then
        apply_wallpaper "$2"
      else
        echo "Error: --apply requires wallpaper path argument"
        exit 1
      fi
      ;;
    "--select-dir")
      zenity_fallback --select-dir
      ;;
    "--help"|"-h")
      echo "Usage: change-wallpaper [OPTIONS]"
      echo "Options:"
      echo "  --apply PATH    Apply specific wallpaper"
      echo "  --select-dir    Force directory selection"
      echo "  --help, -h      Show this help"
      ;;
    *)
      main
      ;;
  esac
''
