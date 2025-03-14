{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Applications
      "$mainMod, Return, exec, $terminal"
      "$mainMod, B, exec, $browser"
      "$mainMod, E, exec, $filemanager"
      "$mainMod SHIFT, C, exec, $calculator"

      # Windows
      "$mainMod, Q, killactive"
      "$mainMod, F, fullscreen"
      "$mainMod, T, togglefloating"
      "$mainMod SHIFT, T, exec, toggleallfloat"
      "$mainMod, J, togglesplit"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      "$mainMod SHIFT, right, resizeactive, 100 0"
      "$mainMod SHIFT, left, resizeactive, -100 0"
      "$mainMod SHIFT, down, resizeactive, 0 100"
      "$mainMod SHIFT, up, resizeactive, 0 -100"
      "$mainMod, G, togglegroup"
      "$mainMod, K, swapsplit"

      # Actions
      "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      "$mainMod, PRINT, exec, rofi-screenshot"
      "$mainMod CTRL, Q, exec, wlogout"
      "$mainMod CTRL, Return, exec, rofi -show drun -replace -i"

      # Workspaces
      "$mainMod, 1, workspace, 1" # Open workspace 1
      "$mainMod, 2, workspace, 2" # Open workspace 2
      "$mainMod, 3, workspace, 3" # Open workspace 3
      "$mainMod, 4, workspace, 4" # Open workspace 4
      "$mainMod, 5, workspace, 5" # Open workspace 5
      "$mainMod, 6, workspace, 6" # Open workspace 6
      "$mainMod, 7, workspace, 7" # Open workspace 7
      "$mainMod, 8, workspace, 8" # Open workspace 8
      "$mainMod, 9, workspace, 9" # Open workspace 9
      "$mainMod, 0, workspace, 10" # Open workspace 10

      "$mainMod SHIFT, 1, movetoworkspace, 1" # Move ac"tive window to workspace 1
      "$mainMod SHIFT, 2, movetoworkspace, 2" # Move ac"tive window to workspace 2
      "$mainMod SHIFT, 3, movetoworkspace, 3" # Move ac"tive window to workspace 3
      "$mainMod SHIFT, 4, movetoworkspace, 4" # Move ac"tive window to workspace 4
      "$mainMod SHIFT, 5, movetoworkspace, 5" # Move ac"tive window to workspace 5
      "$mainMod SHIFT, 6, movetoworkspace, 6" # Move ac"tive window to workspace 6
      "$mainMod SHIFT, 7, movetoworkspace, 7" # Move ac"tive window to workspace 7
      "$mainMod SHIFT, 8, movetoworkspace, 8" # Move ac"tive window to workspace 8
      "$mainMod SHIFT, 9, movetoworkspace, 9" # Move ac"tive window to workspace 9
      "$mainMod SHIFT, 0, movetoworkspace, 10" # Move ac"tive window to workspace 10

      "$mainMod, Tab, workspace, m+1" # Open next workspace
      "$mainMod SHIFT, Tab, workspace, m-1" # Open previous workspace

      "$mainMod CTRL, 1, exec, moveto 1" # Move all windows to work2space 1
      "$mainMod CTRL, 2, exec, moveto 2" # Move all windows to workspace 2
      "$mainMod CTRL, 3, exec, moveto 3" # Move all windows to workspace 3
      "$mainMod CTRL, 4, exec, moveto 4" # Move all windows to workspace 4
      "$mainMod CTRL, 5, exec, moveto 5" # Move all windows to workspace 5
      "$mainMod CTRL, 6, exec, moveto 6" # Move all windows to workspace 6
      "$mainMod CTRL, 7, exec, moveto 7" # Move all windows to workspace 7
      "$mainMod CTRL, 8, exec, moveto 8" # Move all windows to workspace 8
      "$mainMod CTRL, 9, exec, moveto 9" # Move all windows to workspace 9
      "$mainMod CTRL, 0, exec, moveto 10" # Move all windows to workspace 10

      "$mainMod, mouse_down, workspace, e+1" # Open next workspace
      "$mainMod, mouse_up, workspace, e-1" # Open previous workspace
      "$mainMod CTRL, down, workspace, empty" # Open the next empty workspace

      # Fn keys
      ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%" # Increase brightness by 10%
      ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-" # Reduce brightness by 10%
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+" # Increase volume by 5%
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-" # Reduce volume by 5%
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" # Toggle mute
      ", XF86AudioPlay, exec, playerctl play-pause" # Audio play pause
      ", XF86AudioPause, exec, playerctl pause" # Audio pause
      ", XF86AudioNext, exec, playerctl next" # Audio next
      ", XF86AudioPrev, exec, playerctl previous" # Audio previous
      ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle" # Toggle microphone
      ", XF86Lock, exec, hyprlock" # Open screenlock

      ", code:238, exec, brightnessctl -d smc::kbd_backlight s +10"
      ", code:237, exec, brightnessctl -d smc::kbd_backlight s 10-"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
