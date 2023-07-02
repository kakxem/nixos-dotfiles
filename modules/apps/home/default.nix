#
# Home apps (Configs and packages)
#

{ config, pkgs, lib, user, ... }:

{
  imports = [
    ./zsh.nix
    ./alacritty.nix
  ];
}