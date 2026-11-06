#
# KDE
#

{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf (config.desktop == "kde") {
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  security.pam.services = {
    login.kwallet.enable = lib.mkForce false;
    kde.kwallet.enable = lib.mkForce false;
  };

  programs.kdeconnect.enable = true;

  # Keep GNOME Keyring as the Secret portal backend, like GNOME and niri do.
  # plasma-workspace routes org.freedesktop.impl.portal.Secret to KWallet, which
  # this configuration disables (see kwalletrc in kde/home.nix), so browsers
  # could not fetch their cookie-encryption key in a KDE session. This file
  # takes precedence over the kde-portals.conf from xdg.portal.configPackages,
  # so mirror its remaining entries to keep Plasma's backend choices.
  xdg.portal.config.kde = {
    default = [ "kde" ];
    "org.freedesktop.impl.portal.Settings" = [
      "kde"
      "gtk"
    ];
    "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    "org.freedesktop.impl.portal.Notification" = "plasmanotify";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;

      xkb = {
        layout = "us"; # Keyboard layout
        options = "eurosign:e"; # €-sign
      };
    };

    # Enable pipewire
    pulseaudio.enable = false;
    gvfs.enable = true;
  };

  # Solve conflicts with GNOME
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
}
