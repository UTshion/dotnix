{ pkgs, ... }:
{
  moveto = import ./moveto.nix { inherit pkgs; };
  toggleallfloat = import ./toggleallfloat.nix { inherit pkgs; };
}
