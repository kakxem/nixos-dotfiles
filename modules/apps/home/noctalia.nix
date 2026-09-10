{ inputs, lib, palette, palettes, ... }:

let
  noctaliaTheme =
  let
    p = palettes.${palette};

    # Choose black or white-like text for a saturated color using its perceived
    # brightness. This keeps the "on_*" roles readable for palettes with very
    # different accents (for example Ayu yellow and Gruvbox red).
    hexDigit = {
      "0" = 0; "1" = 1; "2" = 2; "3" = 3;
      "4" = 4; "5" = 5; "6" = 6; "7" = 7;
      "8" = 8; "9" = 9; "a" = 10; "b" = 11;
      "c" = 12; "d" = 13; "e" = 14; "f" = 15;
    };

    channel = color: offset:
      let
        normalized = lib.toLower color;
        high = hexDigit.${builtins.substring offset 1 normalized};
        low = hexDigit.${builtins.substring (offset + 1) 1 normalized};
      in
      high * 16 + low;

    brightness = color:
      299 * channel color 1
      + 587 * channel color 3
      + 114 * channel color 5;

    onColor = color: if brightness color > 128000 then p.black else p.white;
  in
  {
    dark = {
      mPrimary = p.accent;
      mOnPrimary = onColor p.accent;
      mSecondary = p.accent2;
      mOnSecondary = onColor p.accent2;
      mTertiary = p.blue;
      mOnTertiary = onColor p.blue;
      mError = p.red;
      mOnError = onColor p.red;
      mSurface = p.bg;
      mOnSurface = p.fg;
      mSurfaceVariant = p.bg1;
      mOnSurfaceVariant = p.fg_idle;
      mOutline = p.comment;
      mShadow = p.black;
      mHover = p.bg2;
      mOnHover = p.fg;

      terminal = {
        background = p.bg;
        foreground = p.fg;
        cursor = p.accent;
        cursorText = onColor p.accent;
        selectionBg = p.accent;
        selectionFg = onColor p.accent;
        normal = {
          black = p.black;
          red = p.red;
          green = p.green;
          yellow = p.yellow;
          blue = p.blue;
          magenta = p.magenta;
          cyan = p.cyan;
          white = p.white;
        };
        bright = {
          black = p.comment;
          red = p.red;
          green = p.green;
          yellow = p.yellow;
          blue = p.blue;
          magenta = p.magenta;
          cyan = p.cyan;
          white = p.fg0;
        };
      };
    };
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        telemetry_enabled = false;
        polkit_agent = false;
        settings_show_advanced = true;
        launch_apps_as_systemd_services = true;
        panel = {
          attach_control_center = true;
          attach_wallpaper = false;
          # Power → session panel → placement near trigger.
          open_near_click_session = true;
        };

        animation.speed = 1;

        session = {
          # Power → session panel → show shortcuts.
          show_shortcuts = false;
        };
      };

      notification = {
        enable_daemon = true;
        position = "top_center";
      };

      control_center = {
        width = 800;
        sidebar = "full";
        sidebar_section = "full";
        hidden_tabs = [
          "monitor"
          "network"
          "bluetooth"
          "weather"
        ];
      };

      bar.default = {
        start = [
          "active_window"
        ];
        center = [
          "notifications"
          "clock"
          "media"
          "volume"
        ];
        end = [
          "tray"
          "network"
          "bluetooth"
          "session"
        ];
        margin_edge = 0;
        margin_ends = 0;
        radius = 0;
        shadow = false;
        widget_spacing = 15;
        hover_highlight = false;
      };

      widget.tray = {
        hide_passive = false;
      };

      dock = {
        enabled = false;
        auto_hide = true;
        launcher_position = "start";
        show_dots = true;
        reserve_space = false;
      };

      theme = {
        # Keep one custom palette identity; rebuild-home regenerates its JSON
        # from vars.palette, just like the GTK and Kvantum theme files.
        mode = "dark";
        source = "custom";
        custom_palette = "custom-theme";
        pure_black_dark = true;
      };

      audio = {
        enable_overdrive = true;
      };

      weather = {
        enabled = false;
      };
    };

    customPalettes."custom-theme" = noctaliaTheme;
  };
}
