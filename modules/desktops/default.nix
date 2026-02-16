#
# Desktop selection module
# Defines the desktop option and imports all desktop modules
# Each desktop module uses mkIf to conditionally enable itself
#
{ config, lib, ... }:

{
  options.desktop = lib.mkOption {
    type = lib.types.enum [ "gnome" "hyprland" "kde" "cosmic" "niri" ];
    default = "gnome";
    description = "Desktop environment to use";
  };

  imports = [
    ./gnome/default.nix
    ./hyprland/default.nix
    ./kde/default.nix
    ./niri/default.nix
    # ./cosmic/default.nix
  ];
}
