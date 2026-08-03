#
# Home apps (Home-manager level)
#

{ pkgs, ... }:

{
  imports = [
    ./autostart.nix
    ./mime-apps.nix
    ./terminal
    ./editors
    ./media
    ./gaming
  ];

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
