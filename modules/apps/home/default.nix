#
# Home apps (Home-manager level)
#

{ pkgs, ... }:

{
  imports = [
    ./terminal
    ./editors
    ./media
  ];

  home.packages = with pkgs; [
    # Personal
    brave
    proton-pass
    protonvpn-gui
    hexchat
    telegram-desktop
    xorg.xlsclients
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
    opencode
    vscode-fhs
  ];
}
