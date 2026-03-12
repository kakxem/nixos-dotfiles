#
# Home apps (Home-manager level)
#

{ pkgs, inputs, ... }:

{
  imports = [
    ./terminal
    ./editors
    ./media
  ];

  home.packages = with pkgs; [
    # Personal
    baobab
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
    docker-compose
    bun
    nodejs_24
    mission-center
    inputs.opencode.packages.${pkgs.system}.default
    vscode-fhs
  ];
}
