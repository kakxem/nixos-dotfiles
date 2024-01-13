#
# Gaming
#

{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    steam
    wineWowPackages.base

    # Tools
    r2modman
  ];

  programs = {                                  # Needed to succesfully start Steam
    steam = {
      enable = true;
    };

    # -- Gamemode installation --
    #
    # *Steam* : Right-click game - Properties - Launch options: gamemoderun %command%
    #
    # *Lutris* : General Preferences - Enable Feral GameMode - Global options - Add Environment Variables:
    # LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
    #
    gamemode.enable = true;                     # Better gaming performance
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];                                            # Use Steam for Linux libraries
}
