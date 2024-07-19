#
#  Hyprland
#

{ pkgs, system, inputs, ... }:

{
  # Cachix
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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
      NVD_BACKEND = "direct";
    };
   

    systemPackages = with pkgs; [
      grim
      ulauncher
      slurp
      swappy
      xdg-desktop-portal
      wl-clipboard
      wlr-randr
      libnotify
      swaynotificationcenter
      hyprpaper
      eog
      nautilus
      via
    ];
  };


  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Gnome keyring
  security.pam.services.gdm.enableGnomeKeyring = true;
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;

      xkb = {
        layout = "us";                          # Keyboard layout
        options = "eurosign:e";                 # €-sign
      };

      displayManager.gdm.enable = true;           # Display Manager
    };
    udisks2.enable = true;

    dbus.implementation = "broker";
    dbus.packages = with pkgs; [
      gcr
      gnome.gnome-settings-daemon
    ]; 
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      via
    ];
  };

  xdg.portal = {                                  # Required for flatpak with window managers and for file browsing
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable pipewire
  hardware.pulseaudio.enable = false;
}
