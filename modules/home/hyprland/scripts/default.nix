{ pkgs, ... }:
{
  moveto = import ./moveto.nix { inherit pkgs; };
  toggleallfloat = import ./toggleallfloat.nix { inherit pkgs; };
  wallpaper-changer = import ./wallpaper-changer.nix { inherit pkgs; };
  wallpaper-random = import ./wallpaper-random.nix { inherit pkgs; };
  # update-starship-pywal = import ./update-starship-pywal.nix { inherit pkgs; };
  change-wallpaper = import ./change-wallpaper.nix { inherit pkgs; };
  # pywal-env-setup = import ./pywal-env-setup.nix { inherit pkgs; };
  ags-wallpaper-launcher = import ./ags-wallpaper-launcher.nix { inherit pkgs; };
}
