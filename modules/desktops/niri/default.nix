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
    security.pam.services."gdm-launch-environment".rules.session.env-greeter = {
      order = config.security.pam.services."gdm-launch-environment".rules.session.env.order + 50;
      control = "required";
      modulePath = "${config.security.pam.package}/lib/security/pam_env.so";
      settings.conffile = pkgs.writeText "gdm-launch-environment-env.conf" ''
        PATH          DEFAULT="''${PATH}:${pkgs.gnome-session}/bin"
        XDG_DATA_DIRS DEFAULT="''${XDG_DATA_DIRS}:${config.services.displayManager.generic.environment.XDG_DATA_DIRS}"
      '';
      settings.readenv = 0;
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
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
    };

    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      grim
      slurp
      swappy
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wl-clipboard
      libnotify
      # Niri can automatically spawn Xwayland via xwayland-satellite when it's in $PATH.
      # See: https://niri-wm.github.io/niri/Xwayland.html#using-xwayland-satellite
      xwayland-satellite
      kdePackages."kdeconnect-kde"
      nautilus
      seahorse
      glib
      gsettings-desktop-schemas
      gtk3
    ];

    # Solve conflicts with GNOME (and ensure a consistent askpass provider).
    programs.ssh.askPassword = mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
