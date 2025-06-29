{ pkgs }:

pkgs.writeShellScriptBin "moveto" ''
  #!${pkgs.bash}/bin/bash
  # Function to log messages
  log_message() {
    echo "[$(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')] $1"
  }

  # Get the target workspace from the argument
  target_workspace=$1

  # Check if a target workspace was provided
  if [ -z "$target_workspace" ]; then
    log_message "Error: No target workspace provided"
    exit 1
  fi

  # Get the current active workspace
  current_workspace=$(${pkgs.hyprland}/bin/hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.workspace.id')
  if [ -z "$current_workspace" ]; then
    log_message "Error: Couldn't determine current workspace"
    exit 1
  fi

  log_message "Moving from workspace $current_workspace to $target_workspace"

  # Get all window addresses in the current workspace
  window_addresses=$(${pkgs.hyprland}/bin/hyprctl clients -j | \
    ${pkgs.jq}/bin/jq -r ".[] | select(.workspace.id == $current_workspace) | .address")

  # Move each window to the target workspace
  for address in $window_addresses; do
    log_message "Moving window $address to workspace $target_workspace"
    ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspacesilent "$target_workspace,address:$address"
  done

  log_message "Finished moving windows"

  # Switch to the target workspace
  ${pkgs.hyprland}/bin/hyprctl dispatch workspace "$target_workspace"
  log_message "Switched to workspace $target_workspace"
''
