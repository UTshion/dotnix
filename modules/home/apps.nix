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
    postman
    pureref
    qalculate-gtk
    slack
    thunderbird
    vlc
    zoom-us
  ];
}
