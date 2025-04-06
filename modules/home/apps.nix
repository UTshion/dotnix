{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    discord
    dbeaver-bin
    github-desktop
    kicad
    obsidian
    obs-studio
    pureref
    qalculate-gtk
    slack
    thunderbird
    vlc
    zoom-us
  ];
}
