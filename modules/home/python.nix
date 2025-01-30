{ pkgs, ... }:
{
  home.packages = with pkgs; [
    black
    rye
    ruff
  ];
}
