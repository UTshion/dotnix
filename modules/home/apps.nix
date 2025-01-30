{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki
    discord
    obsidian
    pureref
    slack
  ];
}
