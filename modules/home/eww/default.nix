# modules/home/eww/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    procps
    overskride # Bluetoothツール (Bluemanの代わり)
    pavucontrol # Pipewireでも使用可能
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # ewwデーモンの自動起動は、Hyprlandの設定で行う

  home.file = {
    # メイン設定ファイル
    ".config/eww/eww.yuck".source = ./files/eww.yuck;
    ".config/eww/eww.scss".source = ./files/eww.scss;

    # スクリプトファイルのコピー（ディレクトリごと）
    ".config/eww/scripts" = {
      source = ./files/scripts;
      recursive = true;
      executable = true; # スクリプトに実行権限を付与
    };
  };
}
