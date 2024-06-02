#
#  General Home-manager configuration
#

{ pkgs, user, ... }:

{ 
  imports = [
    # ../modules/desktops/gnome/home.nix      # GNOME
    ../modules/desktops/hyprland/home.nix   # HYPRLAND
    ../modules/apps/home
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
    packages = with pkgs; [
      # Personal
      firefox
      _1password-gui
      hexchat
      mpv
      telegram-desktop
      xclip
      xorg.xlsclients
      alacritty
      vesktop

      # Work
      distrobox
      docker-compose
      bun
    ];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "kakxem";
      userEmail = "80788785+kakxem@users.noreply.github.com";
      
      extraConfig = {
        commit.gpgsign = true;
      };
      signing.key = "0xF3F43B339BE91890";
    };
  };

}
