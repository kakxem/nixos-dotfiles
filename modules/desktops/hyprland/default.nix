#
#  Hyprland
#

{ config, pkgs, inputs, lib, ... }:

lib.mkIf (config.desktop == "hyprland") {
  # Cachix
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
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
      pavucontrol
      gnome-software
      gnome-system-monitor
    ];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Gnome keyring
  security.pam.services.gdm.enableGnomeKeyring = true;
  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;

      xkb = {
        layout = "us"; # Keyboard layout
        options = "eurosign:e"; # €-sign
      };

      displayManager.gdm.enable = true; # Display Manager
    };
    udisks2.enable = true;

    dbus.implementation = "broker";
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    # Enable pipewire
    pulseaudio.enable = false;
  };

  xdg.portal = {
    # Required for flatpak with window managers and for file browsing
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
