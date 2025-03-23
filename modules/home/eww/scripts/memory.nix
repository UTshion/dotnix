# modules/home/eww/scripts/memory.nix
{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScriptBin "get-memory" ''
    # メモリ使用量をfreeコマンドから取得
    mem_info=$(free -m | grep Mem)
    total_mem=$(echo "$mem_info" | awk '{print $2}')
    used_mem=$(echo "$mem_info" | awk '{print $3}')
    mem_percentage=$(( (used_mem * 100) / total_mem ))

    echo "$mem_percentage"
  '';
in
{
  home.packages = [ script ];
  
  home.file.".config/eww/scripts/get-memory".source = "${script}/bin/get-memory";
}
