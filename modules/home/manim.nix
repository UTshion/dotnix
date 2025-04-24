{ pkgs, ... }:
{
  home.packages = with pkgs; [
    manim # 3B1B-like animation using Python (Community Edition)
];
}
