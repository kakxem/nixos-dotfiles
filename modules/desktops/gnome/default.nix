#
# Gnome configuration
#

{ config, lib, pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  services = {
    xserver = {
      enable = true;

      layout = "us";                          # Keyboard layout
      xkbVariant = "dvorak";
      xkbOptions = "eurosign:e";                  # €-sign

      displayManager.gdm.enable = true;           # Display Manager
      desktopManager.gnome.enable = true;         # Window Manager

    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  environment = {
    systemPackages = with pkgs; [                 # Packages installed
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      gnome.gnome-software
    ];

    gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
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
    ]);
  };

  # Enable pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
}
