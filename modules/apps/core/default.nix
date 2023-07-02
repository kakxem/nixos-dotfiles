#
# Core apps (Apps that needs to be placed here)
#

{ config, pkgs, lib, user, ... }:

{
  imports = [
    ./flatpak.nix
    ./gaming.nix
  ];
}