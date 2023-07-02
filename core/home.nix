#
#  General Home-manager configuration
#

{ config, lib, pkgs, unstable, user, ... }:

{ 
  imports = [
    ../modules/desktops/gnome/home.nix
    (import ../modules/apps/home/default.nix)
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";
    packages = with pkgs; [
      # Personal
      firefox
      _1password-gui
      hexchat
      anki
      mpv

      # Work
      vscode
      mongodb-compass
      nodejs_18
      nodePackages.pnpm
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
