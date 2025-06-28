{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # Avoid conflict with uwsm.
    systemd.enable = false;
  };

  home.file.".config/uwsm/env".text = ''
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export SDL_IM_MODULE=fcitx
    export GLFW_IM_MODULE=ibus
  '';

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursor-theme";
    size = 16;
  };

  gtk = {
    enable = true;

    # theme = {
    #   package = pkgs.whitesur-gtk-theme;
    #   name = "Whitesur-like-gtk-theme";
    # };

    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    dunst
    grimblast
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    slurp
    wl-clipboard
  ];
}
