#
# Home apps (Home-manager level)
#

{ pkgs, ... }:

{
  imports = [
    ./autostart.nix
    ./brave.nix
    ./mime-apps.nix
    ./terminal
    ./editors
    ./media
    ./gaming
  ];

  home.packages = with pkgs; [
    # Personal
    baobab
    proton-pass
    proton-vpn
    telegram-desktop
    papers
    xlsclients
    (discord.override {
      withVencord = true;
    })
    # Work
    distrobox
    distroshelf
    docker-compose
    bun
    nodejs_24
    mission-center
  ];
}
