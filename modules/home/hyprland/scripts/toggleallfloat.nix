{ pkgs, ... }:

pkgs.writeShellScriptBin "toggleallfloat" ''
  #!${pkgs.bash}/bin/bash
  hyprctl dispatch workspaceopt allfloat
  notify-send "Windows on this workspace toggled to floating/tiling"
''
