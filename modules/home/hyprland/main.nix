{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # Conflict with uwsm.
    # systemd.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursor-theme";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.whitesur-gtk-theme;
      name = "Whitesur-like-gtk-theme";
    };

    iconTheme = {
      package = pkgs.nordzy-icon-theme;
      name = "Nordzy";
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    dunst
    eww
    grimblast
    hypridle
    hyprlock
    hyprpaper
    slurp
    wl-clipboard
  ];
}
