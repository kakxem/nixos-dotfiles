#
# Flatpak — sandbox theming bridge.
#
# Flatpak apps run sandboxed and, by default, can't see host themes, icons or
# the user's GTK css. On this setup Flatpak is installed in the SYSTEM scope
# (/var/lib/flatpak), so:
#   - we expose the Adwaita icons + adw-gtk3 themes via ro bindfs mounts,
#     pointing straight at the nix store paths (NOT at config.system.path,
#     which would create an evaluation recursion with environment.systemPackages);
#   - we apply `flatpak override --system` filesystem grants on every rebuild
#     so GTK3/GTK4 apps also read the user's gtk.css (palette accent).
#
{ pkgs, ... }:

let
  mkRoSymBind = pkgPath: {
    device = pkgPath;
    fsType = "fuse.bindfs";
    options = [
      "ro"
      "resolve-symlinks"
      "x-gvfs-hide"
    ];
  };
in
{
  services.flatpak.enable = true;

  # Add flathub repo automatically
  environment.etc = {
    "flatpak/remotes.d/flathub.flatpakrepo".source = pkgs.fetchurl {
      url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
    };
  };

  # Machine-wide access to themes + icons for Flatpak apps.
  # Device points at the package store path directly to avoid recursion.
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = {
    "/usr/share/icons" = mkRoSymBind "${pkgs.adwaita-icon-theme}/share/icons";
    "/usr/share/themes" = mkRoSymBind "${pkgs.adw-gtk3}/share/themes";
  };

  # Apply filesystem grants for the SYSTEM-scope Flatpak apps. Runs as root
  # during each system rebuild.
  system.activationScripts.flatpak-gtk-theming.text = ''
    if command -v flatpak >/dev/null 2>&1; then
      ${pkgs.flatpak}/bin/flatpak --system override --filesystem=/usr/share/themes >/dev/null 2>&1 || true
      ${pkgs.flatpak}/bin/flatpak --system override --filesystem=/usr/share/icons >/dev/null 2>&1 || true
      ${pkgs.flatpak}/bin/flatpak --system override --filesystem=xdg-config/gtk-3.0 >/dev/null 2>&1 || true
      ${pkgs.flatpak}/bin/flatpak --system override --filesystem=xdg-config/gtk-4.0 >/dev/null 2>&1 || true
      # Qt theming via Kvantum (installed runtime org.kde.KStyle.Kvantum//6.10).
      # Global (applies to Qt Flatpak apps) + the user's generated custom theme.
      ${pkgs.flatpak}/bin/flatpak --system override \
        --env=QT_STYLE_OVERRIDE=kvantum \
        --filesystem=xdg-config/Kvantum:ro >/dev/null 2>&1 || true
      ${pkgs.flatpak}/bin/flatpak --system override \
        --env=QT_STYLE_OVERRIDE=kvantum \
        --filesystem=xdg-config/Kvantum:ro \
        org.qbittorrent.qBittorrent >/dev/null 2>&1 || true
    fi
  '';
}
