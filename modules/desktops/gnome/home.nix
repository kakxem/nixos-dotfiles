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
    adw-gtk3
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "app.zen_browser.zen.desktop"
        "org.gnome.Nautilus.desktop"
        "vesktop.desktop"
        "org.telegram.desktop.desktop"
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
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
      focus-mode = "sloppy";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accle-profile = "flat";
      natural-scroll = false;
    };
    "org/gnome/gnome-session" = {
      auto-save-session = "true";
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
    "org/gnome/desktop/background" = {
      picture-uri = "#";
      picture-uri-dark = "#";
      primary-color = "#000000";
      secondary-color = "#000000";
      picture-options = "none";
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
      panel-in-overview = true;
      search = false;
      workspace-switcher-size = 15;
    };
    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      stacking-with-mouse = false;
      gap-inner = 0;
      gap-outer = 0;
    };

  };
}
