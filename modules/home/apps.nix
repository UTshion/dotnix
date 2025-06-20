{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    bitwarden-desktop
    bitwarden-menu
    discord
    dbeaver-bin
    evince
    github-desktop
    kicad
    obsidian
    obs-studio
    pavucontrol
    postman
    pureref
    qalculate-gtk
    slack
    thunderbird
    uxplay
    vlc
    zoom-us
  ];
}
