#
#  General Home-manager configuration
#

{ pkgs, user, desktop, ... }:

let
  desktopHomeModules = {
    gnome = [ ../modules/desktops/gnome/home.nix ];
    hyprland = [ ../modules/desktops/hyprland/home.nix ];
    kde = [ ];
    cosmic = [ ];
  };
in
{
  imports = [
    ../modules/apps/home
  ] ++ (desktopHomeModules.${desktop} or []);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
  };

}
