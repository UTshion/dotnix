{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    discord
    github-desktop
    kicad
    obsidian
    obs-studio
    overskride # A Bluetooth and Obex client
    pureref
    qalculate-gtk
    rofi-screenshot
    slack
    thunderbird
    vlc
    zoom-us
  ];
}
