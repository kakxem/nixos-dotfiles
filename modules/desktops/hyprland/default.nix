#
#  Hyprland
#

{ pkgs, system, hyprland, ... }:

{
  environment = {
    sessionVariables = rec {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";

      # Nvidia
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
   

    systemPackages = with pkgs; [
      grim
      slurp
      swappy
      wl-clipboard
      wlr-randr
      wofi
      libnotify
      swaynotificationcenter
      hyprpaper
      gnome.eog
      libsForQt5.dolphin
      libsForQt5.kate
      libsForQt5.ark
    ];
  };


  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  # Gnome keyring
  security.pam.services.gdm.enableGnomeKeyring = true;
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      layout = "us";                              # Keyboard layout
      displayManager.gdm.enable = true;           # Display Manager
    };
    udisks2.enable = true;
  };

  xdg.portal = {                                  # Required for flatpak with window managers and for file browsing
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
