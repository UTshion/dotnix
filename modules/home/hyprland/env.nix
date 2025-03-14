{
  wayland.windowManager.hyprland.settings = {
    env = [
      # UWSMを利用する場合はここに書くべきではない

      # Not necessary as UWSM sets it up automatically.

      # XDG Desktop Portal
      # "XDG_CURRENT_DESKTOP,Hyprland"
      # "XDG_SESSION_TYPE,wayland"
      # "XDG_SESSION_DESKTOP,Hyprland"

      # QT
      # "QT_QPA_PLATFORM,wayland;xcb"
      # "QT_QPA_PLATFORMTHEME,qt6ct"
      # "QT_QPA_PLATFORMTHEME,qt5ct"
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "QT_AUTO_SCREEN_SCALE_FACTOR,1"

      # GDK
      # "GDK_SCALE,1"

      # Toolkit Backend
      # "GDK_BACKEND,wayland,x11,*"
      # "CLUTTER_BACKEND,wayland"

      # Mozilla
      # "MOZ_ENABLE_WAYLAND,1"

      # Set the cursor size for xcursor
      # "XCURSOR_SIZE,24"

      # Ozone
      # "OZONE_PLATFORM,wayland"
      # "ELECTRON_OZONE_PLATFORM_HINT,wayland"
    ];
  };
}
