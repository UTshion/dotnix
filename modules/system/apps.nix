{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gns3-server
    libreoffice

    # remote desktop-
    moonlight-qt
    sunshine
  ];
}
