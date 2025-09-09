{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 0.8;
      fullscreen_opacity = 1.0;

      blur = {
        enabled = true;
        size = 6;
        passes = 4;
        new_optimizations = true;
        ignore_opacity = true;
        xray = true;
        # blurls = waybar

      };
      shadow = {
        enabled = true;
        color = "0x66000000";
        range = 30;
        render_power = 3;
      };
    };
  };
}
