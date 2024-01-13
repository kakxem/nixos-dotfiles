#
#  Hyprland
#

{ pkgs, system, hyprland, ... }:

let
  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'adw-gtk3-dark'
      gsettings set $gnome_schema color-scheme prefer-dark
    '';
  };

in
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
      xdg-desktop-portal-hyprland
      wofi
      hyprpaper
      gnome.nautilus
      gnome-text-editor
      gnome.eog

      # Themes
      glib
      configure-gtk
      adw-gtk3
      nwg-look
    ];
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      layout = "us";                          # Keyboard layout
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
