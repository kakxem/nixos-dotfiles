#
#  General Home-manager configuration
#

{ pkgs, user, ... }:

{ 
  imports = [
    #../modules/desktops/gnome/home.nix      # GNOME
    ../modules/desktops/hyprland/home.nix   # HYPRLAND
    ../modules/apps/home
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
      telegram-desktop
      xclip
      xorg.xlsclients
      alacritty
      discord

      # Work
      distrobox
      mongodb-compass
      nodejs_18
      nodePackages.pnpm
    ];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "kakxem";
      userEmail = "paul.antonio.almasi@gmail.com";
    };
  };
}
