#
# Gaming
#

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.base

    # Tools
    r2modman
    mangohud
  ];

  environment.variables = {
    PROTON_ENABLE_WAYLAND = 1;
    PROTON_ENABLE_HDR = 1;
    PROTON_FSR4_UPGRADE = 1;
  };

  programs = {
    # Needed to succesfully start Steam
    steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # -- Gamemode installation --
    #
    # *Steam* : Right-click game - Properties - Launch options: gamemoderun %command%
    #
    # *Lutris* : General Preferences - Enable Feral GameMode - Global options - Add Environment Variables:
    # LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
    #
    gamemode.enable = true; # Better gaming performance
  };

  hardware.xone.enable = true; # Xbox controller support
}
