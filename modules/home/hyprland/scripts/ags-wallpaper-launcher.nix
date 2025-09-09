{ pkgs }:

pkgs.writeShellScriptBin "ags-wallpaper-launcher" ''
  #!/usr/bin/env bash
  
  AGS_CONFIG="$HOME/.config/ags-wallpaper"
  
  # 既存のAGSインスタンスを終了
  ${pkgs.ags}/bin/ags -q 2>/dev/null || true
  sleep 0.5
  
  # 専用設定で壁紙選択AGSを起動（TypeScript対応）
  ${pkgs.ags}/bin/ags -b ags-wallpaper -c "$AGS_CONFIG/config.js"
''