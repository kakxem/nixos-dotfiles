{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.desktop;
in
{
  config = mkIf (cfg == "niri") {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    programs.kdeconnect = {
      enable = true;
      package = pkgs.kdePackages."kdeconnect-kde";
    };

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
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          options = "eurosign:e";
        };
      };
      displayManager.gdm.enable = true;
    };

    programs.dms-shell = {
      enable = true;
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wl-clipboard
      libnotify
      # Niri can automatically spawn Xwayland via xwayland-satellite when it's in $PATH.
      # See: https://niri-wm.github.io/niri/Xwayland.html#using-xwayland-satellite
      xwayland-satellite
      kdePackages."kdeconnect-kde"
      nautilus
      gnome-system-monitor
      seahorse
    ];

    # Solve conflicts with GNOME (and ensure a consistent askpass provider).
    programs.ssh.askPassword = mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
