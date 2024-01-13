#
# KDE
#

{ pkgs, system, kde2nix, ... }:

{
  imports = [
    kde2nix.nixosModules.default
  ];

  services.xserver.desktopManager.plasma6.enable = true;
}

