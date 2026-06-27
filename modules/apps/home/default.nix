#
# Home apps (Home-manager level)
#

{ pkgs, ... }:

{
  imports = [
    ./terminal
    ./editors
    ./media
    ./gaming
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/pdf" = [ "org.gnome.Papers.desktop" ];
      "x-directory/normal" = [ "org.gnome.Nautilus.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
    };
  };

  home.packages = with pkgs; [
    # Personal
    baobab
    brave
    proton-pass
    proton-vpn
    hexchat
    telegram-desktop
    papers
    xlsclients
    (discord.override {
      withVencord = true;
    })
    vesktop
    anki

    # Work
    distrobox
    distroshelf
    docker-compose
    bun
    nodejs_24
    mission-center
    vscode-fhs
  ];
}
