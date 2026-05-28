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
    proton-vpn
    hexchat
    telegram-desktop
    xlsclients
    vesktop
    anki

    # Work
    distrobox
    distroshelf
    docker-compose
    bun
    nodejs_24
    mission-center
    (inputs.opencode.packages.${pkgs.system}.default.overrideAttrs (old: {
      preBuild = (old.preBuild or "") + ''
        sed -i -E 's#"packageManager": "bun@[^"]+"#"packageManager": "bun@${pkgs.bun.version}"#' package.json
      '';
    }))
    vscode-fhs
  ];
}
