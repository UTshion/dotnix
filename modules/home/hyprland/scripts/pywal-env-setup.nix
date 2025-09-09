{ pkgs }:

pkgs.writeShellScriptBin "pywal-env-setup" ''
  #!/usr/bin/env bash
  
  # pywalカラーキャッシュファイル
  PYWAL_COLORS="$HOME/.cache/wal/colors.sh"
  PYWAL_STARSHIP_CONFIG="$HOME/.cache/wal/starship-pywal.toml"
  NIXOS_STARSHIP_CONFIG="$HOME/.config/starship.toml"
  STARSHIP_ENV="$HOME/.cache/wal/starship-env"
  
  if [ -f "$PYWAL_COLORS" ]; then
    echo "Creating pywal-enabled Starship config..."
    
    # pywalカラーを読み込み
    source "$PYWAL_COLORS"
    
    # ディレクトリ作成
    mkdir -p "$(dirname "$PYWAL_STARSHIP_CONFIG")"
    
    # NixOS設定をベースにpywal版設定ファイルを作成
    cp "$NIXOS_STARSHIP_CONFIG" "$PYWAL_STARSHIP_CONFIG"
    
    # sedを使ってpywalパレットセクションを更新
    ${pkgs.gnused}/bin/sed -i "s|color_fg0 = \"#fbf1c7\"|color_fg0 = \"$foreground\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_bg1 = \"#3c3836\"|color_bg1 = \"$color1\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_bg3 = \"#665c54\"|color_bg3 = \"$color8\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_blue = \"#458588\"|color_blue = \"$color4\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_aqua = \"#689d6a\"|color_aqua = \"$color6\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_green = \"#98971a\"|color_green = \"$color2\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_orange = \"#d65d0e\"|color_orange = \"$color9\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_purple = \"#b16286\"|color_purple = \"$color5\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_red = \"#cc241d\"|color_red = \"$color1\"|" "$PYWAL_STARSHIP_CONFIG"
    ${pkgs.gnused}/bin/sed -i "s|color_yellow = \"#d79921\"|color_yellow = \"$color3\"|" "$PYWAL_STARSHIP_CONFIG"
    
    # パレット選択をpywalに変更
    ${pkgs.gnused}/bin/sed -i 's|palette = "gruvbox_dark"|palette = "pywal"|' "$PYWAL_STARSHIP_CONFIG"
    
    echo "Pywal Starship config created successfully"
    
    # 環境変数でpywal設定ファイルを使用するよう設定
    cat > "$STARSHIP_ENV" << 'EOF'
export STARSHIP_CONFIG="$HOME/.cache/wal/starship-pywal.toml"
EOF
    
    echo "Pywal Starship config activated"
    
  else
    echo "Pywal colors not found, using default NixOS config..."
    
    # デフォルト設定に戻す（環境変数をクリア）
    cat > "$STARSHIP_ENV" << 'EOF'
# Using default NixOS starship config
unset STARSHIP_CONFIG
EOF
    
    # pywal設定ファイルが存在すれば削除
    [ -f "$PYWAL_STARSHIP_CONFIG" ] && rm "$PYWAL_STARSHIP_CONFIG"
    
    echo "Default NixOS Starship config restored"
  fi
  
  echo "Starship configuration updated. Please restart your terminal or run 'source ~/.cache/wal/starship-env'"
''
