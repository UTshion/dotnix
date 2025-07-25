# modules/home/eww/scripts/cpu.nix
{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScriptBin "get-cpu" ''
    # CPU使用率を取得
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
    echo "$cpu_usage"
  '';
in
{
  home.packages = [ script ];
  
  home.file.".config/eww/scripts/get-cpu".source = "${script}/bin/get-cpu";
}
