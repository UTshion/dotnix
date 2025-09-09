{ pkgs, ... }:

let
  scripts = import ./scripts { inherit pkgs; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Avoid conflict with uwsm.
    systemd.enable = false;
  };

  home.file.".config/uwsm/env".text = ''
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

    theme = {
      package = pkgs.whitesur-gtk-theme.override {
        darkerColor = true;
        colorVariants = ["dark"];
        themeVariants = ["default"];
      };
      name = "Whitesur-dark";
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
    ags
    brightnessctl
    cliphist
    dunst
    grimblast
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    pywal
    slurp
    wl-clipboard
    zenity
  ];

  # 専用AGS壁紙選択設定ファイル（既存のAGSと分離）
  home.file.".config/ags-wallpaper/config.js" = {
    source = ./scripts/ags-wallpaper-selector.ts;
    executable = false;
  };

  # 専用AGS CSS設定
  home.file.".config/ags-wallpaper/style.css".text = ''
    .main-container {
      background-color: rgba(0, 0, 0, 0.9);
      border-radius: 10px;
      margin: 20px;
      padding: 20px;
    }

    .header {
      padding: 10px 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.2);
      margin-bottom: 20px;
    }

    .title {
      font-size: 18px;
      font-weight: bold;
      color: white;
    }

    .dir-button, .close-button, .cancel-button, .apply-button {
      padding: 8px 16px;
      margin-left: 10px;
      border-radius: 5px;
      border: none;
      font-weight: bold;
    }

    .dir-button {
      background-color: rgba(100, 149, 237, 0.8);
      color: white;
    }

    .close-button, .cancel-button {
      background-color: rgba(220, 53, 69, 0.8);
      color: white;
    }

    .apply-button {
      background-color: rgba(40, 167, 69, 0.8);
      color: white;
    }

    .image-container {
      min-height: 400px;
      max-height: 500px;
    }

    .image-row {
      margin-bottom: 15px;
    }

    .image-button {
      margin: 5px;
      border-radius: 8px;
      border: 2px solid transparent;
      background-color: rgba(255, 255, 255, 0.1);
      padding: 10px;
    }

    .image-button:hover {
      border-color: rgba(100, 149, 237, 0.8);
    }

    .image-button.selected {
      border-color: rgba(40, 167, 69, 0.9);
      background-color: rgba(40, 167, 69, 0.2);
    }

    .image-wrapper {
      border-radius: 5px;
      overflow: hidden;
    }

    .image-name {
      color: white;
      font-size: 12px;
      margin-top: 5px;
    }

    .footer {
      padding: 15px 0;
      border-top: 1px solid rgba(255, 255, 255, 0.2);
      margin-top: 20px;
    }

    .current-info {
      color: rgba(255, 255, 255, 0.8);
      font-size: 12px;
    }

    .error-message {
      color: rgba(220, 53, 69, 0.9);
      padding: 20px;
      text-align: center;
    }
  '';
}
