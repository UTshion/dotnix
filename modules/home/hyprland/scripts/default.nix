{ pkgs, ... }:
{
  moveto = import ./moveto.nix { inherit pkgs; };
  toggleallfloat = import ./toggleallfloat.nix { inherit pkgs; };
  wallpaper-changer = import ./wallpaper-changer.nix { inherit pkgs; };
  wallpaper-random = import ./wallpaper-random.nix { inherit pkgs; };
}
