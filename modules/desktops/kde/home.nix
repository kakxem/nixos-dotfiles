#
# KDE Home-Manager Configuration
#

{
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      # Palette identity from the theming module: it writes the scheme to
      # xdg.dataFile."color-schemes/custom-theme.colors" and leaves kdeglobals
      # to plasma-manager, so apply it by name here.
      colorScheme = "custom-theme";
      iconTheme = "custom-theme-kde";
      cursor = {
        theme = "Breeze_Snow";
        size = 24;
      };
    };

    configFile = {
      # Disable pointer acceleration and keep NumLock enabled after login.
      "kcminputrc"."Mouse"."PointerAccelerationProfile" = 0;
      "kcminputrc"."Keyboard"."NumLock" = 0;

      # Use the Super key for Overview instead of the application launcher.
      "kglobalshortcutsrc"."kwin"."Overview" = "Meta,Meta+W,Toggle Overview";
      "kglobalshortcutsrc"."plasmashell"."activate application launcher" =
        "Alt+F1,Alt+F1,Activate Application Launcher";

      # Keep GNOME Keyring as the Secret Service provider across desktops.
      "kwalletrc"."Wallet"."Enabled" = false;
    };
  };

  gtk = {
    enable = true;
    # The shared theming module owns the GTK theme and icon identity
    # (adw-gtk3-dark + palette icons) on every desktop. These Breeze values
    # stay as lower-priority defaults so the KDE module does not fight it.
    iconTheme = lib.mkDefault {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze";
    };
    theme = lib.mkDefault {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.kdePackages.breeze;
    name = "Breeze_Snow";
    size = 24;
  };
}
