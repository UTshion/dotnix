{ pkgs, ... }:
#
# let
#   startupScript = pkgs.writeShellScript "hyprland-startup" ''
#     #!/usr/bin/env bash
#
#     pkill eww || true
#
#     sleep 1
#
#     eww daemon &
#     sleep 0.5
#     eww open bar
#
#   '';
# in
#
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "wl-paste --type text --watch cliphist store" # Stores only text data
      "wl-paste --type image --watch cliphist store" # Stores only image data
      # startupScript
    ];
  };
}
