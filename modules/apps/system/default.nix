#
# System apps (NixOS level)
#

{ pkgs, ... }:

{
  imports = [
    ./flatpak.nix
    ./gaming.nix
    ./sunshine.nix
    ./virtualization.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    linuxKernel.packages.linux_zen.xone
    xclip
  ];
}
