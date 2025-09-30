{
  config,
  lib,
  pkgs,
  ...
}:

let
  scritps = import ./scripts { inherit pkgs; };
in
{
  imports = [
    ./animations.nix
    ./autostarts.nix
    ./binds.nix
    ./decoration.nix
    ./env.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./layouts.nix
    ./main.nix
    ./variables.nix
    ./windowrules.nix
    ./windows.nix
    ./hyprpaper.nix
  ];

  home.packages = with scritps; [
    moveto
    toggleallfloat
    wallpaper-changer
    wallpaper-random
    change-wallpaper
    ags-wallpaper-launcher
    # pywal-env-setup  # 無効化: NixOS starship設定を使用
  ];
}
