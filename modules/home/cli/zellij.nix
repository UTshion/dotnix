{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

}
