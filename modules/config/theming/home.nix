#
# Theming — transversal (independent of desktop environment).
#
# Applies the active palette to GTK/libadwaita and Qt/Kvantum for every desktop.
#
{ pkgs, lib, palette, palettes, ... }:

let
  p = palettes.${palette};
  # Rebuild the stable Qt theme from the selected palette.
  qtTheme = "custom-theme";
  folderIconTheme = import ../../../theme/generators/folder-icons.nix {
    inherit pkgs palette palettes;
  };

  # Palette variables for adw-gtk3 and libadwaita.
  gtkCss = ''
    @define-color accent_bg_color ${p.accent};
    @define-color accent_fg_color ${p.bg};
    @define-color accent_color ${p.accent};
    @define-color accent_blue ${p.blue};
    @define-color accent_green ${p.green};
    @define-color accent_yellow ${p.yellow};
    @define-color accent_orange ${p.accent};
    @define-color accent_pink ${p.magenta};
    @define-color accent_purple ${p.magenta};
    @define-color accent_red ${p.red};
    @define-color accent_teal ${p.cyan};
    @define-color accent_slate ${p.comment};

    @define-color window_bg_color ${p.bg};
    @define-color window_fg_color ${p.fg};
    @define-color view_bg_color ${p.bg};
    @define-color view_fg_color ${p.fg};
    @define-color headerbar_bg_color ${p.bg1};
    @define-color headerbar_fg_color ${p.fg};
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color popover_bg_color ${p.bg1};
    @define-color popover_fg_color ${p.fg};
    @define-color dialog_bg_color ${p.bg1};
    @define-color dialog_fg_color ${p.fg};
    @define-color card_bg_color ${p.bg1};
    @define-color card_fg_color ${p.fg};
    @define-color sidebar_bg_color ${p.bg1};
    @define-color sidebar_fg_color ${p.fg};
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color destructive_bg_color ${p.red};
    @define-color success_bg_color ${p.green};
    @define-color warning_bg_color ${p.yellow};
    @define-color error_bg_color ${p.red};
  '';

  # Override Nautilus selection and rubber-band colors.
  gtk4Css = gtkCss + ''
    :root {
      --accent-bg-color: ${p.accent};
      --accent-fg-color: ${p.bg};
      --accent-color: ${p.accent};
    }

    /* Nautilus view-local selection colors. */
    .nautilus-list-view listview,
    .nautilus-grid-view gridview,
    .nautilus-network-view listview {
      --accent-bg-color: ${p.accent};
      --accent-color: ${p.accent};
    }

    /* Keep live rubber-band selections accent-colored. */
    .nautilus-list-view columnview > listview > row:active,
    .nautilus-grid-view gridview > child:active,
    .nautilus-network-view listview > row:active {
      background-color: color-mix(in srgb, ${p.accent} 25%, transparent);
    }

    rubberband {
      border-color: ${p.accent};
      background-color: color-mix(in srgb, ${p.accent} 30%, transparent);
    }
  '';

  # Helper: convert #RRGGBB to "R,G,B" (KDE kdeglobals format).
  hexPairToInt = pair:
    builtins.foldl' (acc: c:
      acc * 16 + (if c == "a" then 10 else if c == "b" then 11 else if c == "c" then 12 else if c == "d" then 13 else if c == "e" then 14 else if c == "f" then 15 else builtins.fromJSON c)
    ) 0 (lib.stringToCharacters pair);
  hexToRgb = hex:
    let
      r = builtins.substring 1 2 hex;
      g = builtins.substring 3 2 hex;
      b = builtins.substring 5 2 hex;
    in
      "${toString (hexPairToInt r)},${toString (hexPairToInt g)},${toString (hexPairToInt b)}";

  # KDE color roles, embedded in the generated Kvantum package.
  customColors = ''
    [ColorEffects:Disabled]
    ChangeSelectionColor=
    Color=${hexToRgb p.comment}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    Enable=
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${hexToRgb p.comment}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    BackgroundAlternate=${hexToRgb p.bg2}
    BackgroundNormal=${hexToRgb p.bg1}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Complementary]
    BackgroundAlternate=${hexToRgb p.bg2}
    BackgroundNormal=${hexToRgb p.bg}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Header]
    BackgroundAlternate=${hexToRgb p.bg1}
    BackgroundNormal=${hexToRgb p.bg1}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Header][Inactive]
    BackgroundAlternate=${hexToRgb p.bg1}
    BackgroundNormal=${hexToRgb p.bg}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Selection]
    BackgroundAlternate=${hexToRgb p.accent}
    BackgroundNormal=${hexToRgb p.accent}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.white}
    ForegroundInactive=${hexToRgb p.white}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.white}
    ForegroundNeutral=${hexToRgb p.white}
    ForegroundNormal=${hexToRgb p.white}
    ForegroundPositive=${hexToRgb p.white}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Selection][Inactive]
    BackgroundAlternate=${hexToRgb p.accent}
    BackgroundNormal=${hexToRgb p.accent}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.white}
    ForegroundInactive=${hexToRgb p.white}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.white}
    ForegroundNeutral=${hexToRgb p.white}
    ForegroundNormal=${hexToRgb p.white}
    ForegroundPositive=${hexToRgb p.white}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Tooltip]
    BackgroundAlternate=${hexToRgb p.bg1}
    BackgroundNormal=${hexToRgb p.bg1}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:View]
    BackgroundAlternate=${hexToRgb p.bg}
    BackgroundNormal=${hexToRgb p.bg}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [Colors:Window]
    BackgroundAlternate=${hexToRgb p.bg}
    BackgroundNormal=${hexToRgb p.bg}
    DecorationFocus=${hexToRgb p.accent}
    DecorationHover=${hexToRgb p.accent}
    ForegroundActive=${hexToRgb p.accent}
    ForegroundInactive=${hexToRgb p.fg_idle}
    ForegroundLink=${hexToRgb p.blue}
    ForegroundNegative=${hexToRgb p.red}
    ForegroundNeutral=${hexToRgb p.yellow}
    ForegroundNormal=${hexToRgb p.fg}
    ForegroundPositive=${hexToRgb p.green}
    ForegroundVisited=${hexToRgb p.magenta}

    [General]
    ColorScheme=custom-theme
    Name=${p.name} Custom Theme

    [Icons]
    Theme=custom-theme-kde

    [KDE]
    contrast=4
    frameContrast=0.2

    [WM]
    activeBackground=${hexToRgb p.bg1}
    activeBlend=${hexToRgb p.fg}
    activeForeground=${hexToRgb p.fg}
    inactiveBackground=${hexToRgb p.bg}
    inactiveBlend=${hexToRgb p.fg_idle}
    inactiveForeground=${hexToRgb p.fg_idle}
  '';

  # Reuse one generated theme for Kvantum and KDE.
  customTheme = import ../../../theme/generators/kvantum-theme.nix {
    inherit pkgs palette palettes;
    kdeColors = customColors;
  };

  kdeglobals = builtins.readFile "${customTheme}/share/color-schemes/custom-theme.colors";

in
{
  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = folderIconTheme;
      name = qtTheme;
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Palette-driven accent + surfaces override.
  xdg.configFile."gtk-3.0/gtk.css".text = gtkCss;
  xdg.configFile."gtk-4.0/gtk.css".text = gtk4Css;

  # Dark color scheme at the gsettings level (independent of DE).
  dconf.settings."org/gnome/desktop/interface"."color-scheme" = "prefer-dark";

  # KDE color scheme and matching folder icons.
  xdg.configFile."kdeglobals".text = kdeglobals;
  xdg.dataFile."color-schemes/custom-theme.colors".source =
    "${customTheme}/share/color-schemes/custom-theme.colors";
  xdg.dataFile."icons/custom-theme-kde".source =
    "${folderIconTheme}/share/icons/custom-theme-kde";

  # Qt styling through the generated Kvantum theme.
  qt = {
    enable = true;
    style = {
      name = "kvantum";
    };
    kvantum = {
      enable = true;
      themes = [
        customTheme
      ];
      settings.General.theme = qtTheme;
    };
  };
}
