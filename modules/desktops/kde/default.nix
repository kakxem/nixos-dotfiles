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
