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
