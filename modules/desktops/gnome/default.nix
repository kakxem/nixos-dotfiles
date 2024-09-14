#
# Gnome configuration
#

{  pkgs, ... }:

{
  imports = [
    ./overlays.nix
  ];

  programs = {
    dconf.enable = true;
  };

  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "us";                          # Keyboard layout
        options = "eurosign:e";                 # €-sign
      };

      displayManager.gdm.enable = true;           # Display Manager
      desktopManager.gnome.enable = true;         # Window Manager

    };
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };

  environment = {
    systemPackages = with pkgs; [                 # Packages installed
      dconf-editor
      gnome-tweaks
      adwaita-icon-theme
      gnome-software
      gnome-text-editor
    ];

    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
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
    ]);
  };

  # Enable pipewire
  hardware.pulseaudio.enable = false;
}
