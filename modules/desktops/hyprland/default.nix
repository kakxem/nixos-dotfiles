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
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      wofi
      hyprpaper
      gnome.nautilus
      gnome-text-editor
      gnome.eog
    ];
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
      xwayland = {
        enable = true;
        hidpi = false;
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      layout = "us";                          # Keyboard layout
      xkbVariant = "dvorak";
      displayManager.gdm.enable = true;           # Display Manager
    };
  };

  xdg.portal = {                                  # Required for flatpak with window managers and for file browsing
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nixpkgs.overlays = [    # Waybar with experimental features
    (final: prev: {
      waybar = hyprland.packages.${system}.waybar-hyprland;
    })
  ];
}
