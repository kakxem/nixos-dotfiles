#
# KDE
#

{ pkgs, ... }:

{
  services = {
    desktopManager.plasma6.enable = true;
    # displayManager.sddm.enable = true;
    # displayManager.sddm.wayland.enable = true;

    xserver = {
      enable = true;

      xkb = {
        layout = "us"; # Keyboard layout
        options = "eurosign:e"; # €-sign
      };
    };

    # Enable pipewire
    pulseaudio.enable = false;
  };

  # Solve conflicts with GNOME
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
}
