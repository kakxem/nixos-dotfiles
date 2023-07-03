#
# Gnome Home-Manager Configuration
#
# Dconf settings can be found by running "$ dconf watch /"
#

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell  
    gnomeExtensions.just-perfection
    gnomeExtensions.middle-click-to-close-in-overview
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "middleclickclose@paolo.tranquilli.gmail.com"
        "pop-shell@system76.com"
      ];
    };

    # Apps and system settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
      clock-show-weekday = true;
      gtk-theme = "adw-gtk3-dark";
    };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = "false";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/mutter" = {
      center-new-windows = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/nautilus/preferences" = {
      click-policy = "single";
      search-view = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
    };

    # Keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "open-file-browser";
    };

    # Extensions config
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      app-menu = false;
      panel = false;
      panel-in-overview = true;
      search = false;
      workspace-switcher-size = 13;
    };
    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      stacking-with-mouse = false;
    };

  };
}
