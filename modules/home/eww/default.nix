# modules/home/eww/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    libnotify
    procps
    overskride
    pavucontrol
    font-awesome
  ];

  # ewwデーモンの自動起動は、Hyprlandの設定で行う

  home.file = {
    # メイン設定ファイル
    ".config/eww/eww.yuck".source = ./files/eww.yuck;
    ".config/eww/eww.scss".source = ./files/eww.scss;
  };

  # systemdユーザーサービスとしてewwを管理
  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.eww-wayland}/bin/eww daemon --no-daemonize";
      ExecStopPost = "${pkgs.eww-wayland}/bin/eww close-all";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # ewwバーを起動するサービス
  systemd.user.services.eww-bar = {
    Unit = {
      Description = "Eww Status Bar";
      PartOf = ["graphical-session.target"];
      After = ["eww.service" "graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.eww-wayland}/bin/eww open bar";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
