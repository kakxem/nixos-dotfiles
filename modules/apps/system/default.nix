#
# System apps (NixOS level)
#

{ pkgs, ... }:

{
  imports = [
    ./docker.nix
    ./flatpak.nix
    ./gaming.nix
    ./libvirt.nix
    ./sunshine.nix
    ./waydroid.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    home-manager
    bazaar
    linuxKernel.packages.linux_zen.xone
    xclip
  ];
}
