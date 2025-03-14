{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Hack Nerd Font 10";
    theme = ./rofi.rasi;
    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      display-drun = "APPS";
      display-run = "RUN";
      display-filebrowser = "FILES";
      display-window = "WINDOW";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };
  };

  home.file = {
    ".config/rofi/rofi.rasi".source = ./rofi.rasi;
    ".config/rofi/images/f.png".source = ./f.png;
  };
}
