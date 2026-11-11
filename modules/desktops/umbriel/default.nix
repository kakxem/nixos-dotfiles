#
#  Umbriel
#

{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop;
in
{
  config = mkIf (cfg == "umbriel") {
    programs.umbriel = {
      enable = true;
      package = pkgs.umbriel;
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.kdePackages."kdeconnect-kde";
    };

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;

    networking.firewall.allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    networking.firewall.allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    # Allow GNOME Keyring / Seahorse to provide an SSH_ASKPASS implementation.
    security.pam.services.gdm.enableGnomeKeyring = true;

    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      udisks2.enable = true;
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          options = "eurosign:e";
        };
      };
      displayManager.gdm.enable = true;
      displayManager.defaultSession = "umbriel";
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "Umbriel";
      XDG_SESSION_DESKTOP = "Umbriel";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" [
        pkgs.gst_all_1.gstreamer
        pkgs.gst_all_1.gst-plugins-base
        pkgs.gst_all_1.gst-plugins-good
      ];
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      satty
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wl-clipboard
      libnotify
      kdePackages."kdeconnect-kde"
      nautilus
      seahorse
      glib
      gsettings-desktop-schemas
      gtk3
    ];

    # Solve conflicts with GNOME (and ensure a consistent askpass provider).
    programs.ssh.askPassword = mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

    # Umbriel and the GTK portal cover screen capture and file browsing.
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
