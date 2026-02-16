#
# Gnome configuration
#

{ config, pkgs, lib, ... }:

lib.mkIf (config.desktop == "gnome") {
  programs = {
    dconf.enable = true;
  };

  services = {
    displayManager.gdm.enable = true; # Display Manager
    desktopManager.gnome.enable = true; # Window Manager

    # Enable pipewire
    pulseaudio.enable = false;

    xserver = {
      enable = true;

      xkb = {
        layout = "us"; # Keyboard layout
        options = "eurosign:e"; # €-sign
      };
    };
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      # Packages installed
      dconf-editor
      gnome-tweaks
      adwaita-icon-theme
      gnome-text-editor
      gnome-extension-manager
    ];

    gnome.excludePackages = (
      with pkgs;
      [
        # Gnome ignored packages
        gnome-tour
        epiphany
        geary
        gnome-characters
        tali
        iagno
        hitori
        atomix
        yelp
        gnome-contacts
        gnome-initial-setup
        gnome-music
        gnome-calendar
        gnome-maps
        simple-scan
        cheese
        gnome-software
      ]
    );
  };
}
