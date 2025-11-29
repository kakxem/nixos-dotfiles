#
# Flatpak fix for icons and fonts
#

{ config, pkgs, ... }:

{
  services.flatpak.enable = true; # Flatpak

  # Add flathub repo automatically
  environment.etc = {
    "flatpak/remotes.d/flathub.flatpakrepo".source = pkgs.fetchurl {
      url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
    };
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
