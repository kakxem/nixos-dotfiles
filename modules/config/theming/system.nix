#
# System-wide GTK, icon, and Kvantum support.
#
{ pkgs, ... }:

{
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
  };

  # Make GTK themes and icons available to Flatpak apps.
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
  ];
}
