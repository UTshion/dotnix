# modules/home/eww/scripts/default.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./active-window.nix
    ./cpu.nix
    ./memory.nix
    ./volume.nix
    ./network.nix
    ./bluetooth.nix
    ./system-menu.nix
    ./system-tray.nix
  ];
}
