#
#  General Home-manager configuration
#

{ pkgs, user, desktop ? "gnome", ... }:

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
    packages = with pkgs; [
      # Fonts
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-cove
      noto-fonts-cjk-sans

      # Personal
      brave
      proton-pass
      protonvpn-gui
      hexchat
      telegram-desktop
      xorg.xlsclients
      alacritty
      vesktop
      anki

      # Work
      distrobox
      distroshelf
      gearlever
      docker-compose
      bun
      nodejs_24
      mission-center
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings = {
        user.name = "kakxem";
        user.email = "80788785+kakxem@users.noreply.github.com";
        commit.gpgsign = true;
      };
      signing.key = "0xF3F43B339BE91890";
    };
  };

}
