{ pkgs }:

pkgs.writeShellScriptBin "update-starship-pywal" ''
  #!${pkgs.bash}/bin/bash
  
  STARSHIP_CONFIG="$HOME/.config/starship.toml"
  BACKUP_CONFIG="$HOME/.config/starship.toml.nixos-backup"
  PYWAL_COLORS="$HOME/.cache/wal/colors.sh"
  
  # 関数：ログ出力
  log() {
    echo "[$(date '+%H:%M:%S')] $1"
  }
  
  # 関数：設定ファイルの存在確認
  check_files() {
    if [ ! -f "$STARSHIP_CONFIG" ]; then
      log "エラー: Starship設定ファイルが見つかりません: $STARSHIP_CONFIG"
      return 1
    fi
    
    if [ ! -f "$PYWAL_COLORS" ]; then
      log "警告: pywalカラーファイルが見つかりません。gruvboxに戻します。"
      restore_gruvbox
      return 1
    fi
    
    return 0
  }
  
  # 関数：NixOS設定のバックアップ作成
  backup_nixos_config() {
    if [ ! -f "$BACKUP_CONFIG" ]; then
      log "NixOS設定をバックアップしています..."
      cp "$STARSHIP_CONFIG" "$BACKUP_CONFIG"
      log "バックアップ完了: $BACKUP_CONFIG"
    fi
  }
  
  # 関数：gruvboxに戻す
  restore_gruvbox() {
    log "gruvboxパレットに戻しています..."
    sed -i 's/palette = .*/palette = "gruvbox_dark"/' "$STARSHIP_CONFIG"
    log "gruvboxパレットに切り替えました"
  }
  
  # 関数：pywalカラーの適用
  apply_pywal_colors() {
    local config_file="$1"
    
    log "pywalカラーを読み込んでいます..."
    source "$PYWAL_COLORS"
    
    log "Starship設定にpywalカラーを適用しています..."
    
    # pywalパレットセクションを完全に置き換え
    # セクションの開始と終了を正確に特定して置換
    ${pkgs.python3}/bin/python3 << EOF
import re
import sys

# 設定ファイルを読み込み
with open('$config_file', 'r') as f:
    content = f.read()

# pywalパレットセクションを新しい値で置き換え
pywal_section = '''[palettes.pywal]
color_fg0 = "$foreground"
color_bg1 = "$color1"
color_bg3 = "$color8"
color_blue = "$color4"
color_aqua = "$color6"
color_green = "$color2"
color_orange = "$color9"
color_purple = "$color5"
color_red = "$color1"
color_yellow = "$color3"'''

# 既存のpywalパレットセクションを置き換え
pattern = r'\[palettes\.pywal\][\s\S]*?(?=\n\[|\n\n|\Z)'
if re.search(pattern, content):
    content = re.sub(pattern, pywal_section, content)
    
    # パレット選択をpywalに変更
    content = re.sub(r'palette = .*', 'palette = "pywal"', content)
    
    # ファイルに書き戻し
    with open('$config_file', 'w') as f:
        f.write(content)
    
    print("pywalカラーの適用が完了しました")
else:
    print("エラー: pywalパレットセクションが見つかりません")
    sys.exit(1)
EOF
    
    # Python実行結果をチェック
    if [ $? -eq 0 ]; then
      log "pywalカラーの適用が完了しました"
    else
      log "エラー: pywalカラーの適用に失敗しました"
      return 1
    fi
  }
  
  # 関数：設定の検証
  validate_config() {
    log "設定ファイルの構文をチェックしています..."
    
    # starshipコマンドで設定をテスト
    if starship config 2>/dev/null >/dev/null; then
      log "設定ファイルの構文は正常です"
      return 0
    else
      log "エラー: 設定ファイルに構文エラーがあります"
      
      # バックアップから復旧
      if [ -f "$BACKUP_CONFIG" ]; then
        log "バックアップから復旧しています..."
        cp "$BACKUP_CONFIG" "$STARSHIP_CONFIG"
        restore_gruvbox
        log "バックアップから復旧しました"
      fi
      
      return 1
    fi
  }
  
  # メイン処理
  main() {
    case "$1" in
      "gruvbox"|"--gruvbox")
        log "gruvboxパレットに切り替えます"
        backup_nixos_config
        restore_gruvbox
        validate_config
        ;;
      "pywal"|"--pywal"|"")
        log "pywalパレットに切り替えます"
        check_files || exit 1
        backup_nixos_config
        apply_pywal_colors "$STARSHIP_CONFIG"
        validate_config || exit 1
        ;;
      "restore"|"--restore")
        if [ -f "$BACKUP_CONFIG" ]; then
          log "NixOS設定を復元しています..."
          cp "$BACKUP_CONFIG" "$STARSHIP_CONFIG"
          log "NixOS設定を復元しました"
        else
          log "バックアップファイルが見つかりません"
          exit 1
        fi
        ;;
      "status"|"--status")
        log "現在の設定状態:"
        if grep -q 'palette = "pywal"' "$STARSHIP_CONFIG" 2>/dev/null; then
          log "  パレット: pywal (動的カラー)"
        elif grep -q 'palette = "gruvbox_dark"' "$STARSHIP_CONFIG" 2>/dev/null; then
          log "  パレット: gruvbox_dark (デフォルト)"
        else
          log "  パレット: 不明"
        fi
        
        if [ -f "$BACKUP_CONFIG" ]; then
          log "  バックアップ: 存在"
        else
          log "  バックアップ: なし"
        fi
        
        if [ -f "$PYWAL_COLORS" ]; then
          log "  pywalカラー: 利用可能"
        else
          log "  pywalカラー: 利用不可"
        fi
        ;;
      "help"|"--help"|"-h")
        echo "使用方法: update-starship-pywal [オプション]"
        echo ""
        echo "オプション:"
        echo "  (なし)        pywalカラーを適用"
        echo "  pywal         pywalカラーを適用"
        echo "  gruvbox       gruvboxカラーに切り替え"
        echo "  restore       NixOS設定を復元"
        echo "  status        現在の設定状態を表示"
        echo "  help          このヘルプを表示"
        ;;
      *)
        log "エラー: 不明なオプション '$1'"
        log "使用方法: update-starship-pywal [pywal|gruvbox|restore|status|help]"
        exit 1
        ;;
    esac
    
    # 最後にStarshipプロセスを再起動
    if [ "$1" != "status" ] && [ "$1" != "help" ] && [ "$1" != "--help" ] && [ "$1" != "-h" ]; then
      log "Starshipプロセスを再起動しています..."
      pkill -f starship 2>/dev/null || true
      sleep 1
      log "完了しました"
    fi
  }
  
  # スクリプト実行
  main "$@"
''
