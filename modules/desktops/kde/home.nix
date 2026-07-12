#
# KDE Home-Manager Configuration
#

{
  pkgs,
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
      cursor = {
        theme = "Breeze_Snow";
        size = 24;
      };
      iconTheme = "Breeze";
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
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "Breeze";
    };
    theme = {
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
