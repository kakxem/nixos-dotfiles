#
# Flatpak fix for icons and fonts
#

{ config, pkgs, ... }:

{
  services.flatpak.enable = true; # Flatpak

  # Add flathub repo automatically
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
    in
    {
      # Create an FHS mount to support flatpak host icons
      "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    };
}
