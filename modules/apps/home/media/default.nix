{ pkgs, ... }:

{
  imports = [
    ./mpv.nix
    ./obs.nix
  ];

  home.packages = [ pkgs.spotify ];
}
