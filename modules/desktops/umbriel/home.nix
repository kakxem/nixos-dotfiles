{
  pkgs,
  palette,
  palettes,
  ...
}:

let
  # Active color palette (semantic keys resolved from theme/palettes.nix)
  p = palettes.${palette};

  # Umbriel colors are #RRGGBBAA; the palette stores #RRGGBB.
  rgba = color: alpha: "${color}${alpha}";

  configToml = ''
    # Generated from theme/palettes.nix by modules/desktops/umbriel/home.nix.
    # Edits here are overwritten; change the palette or this module instead.

    [general]
    mod_key = "Super"

    [appearance]
    prefer_no_csd = true
    border_width = 2
    corner_radius = 15
    drag_opacity = 0.85

    [appearance.blur]
    enabled = true
    optimized = true
    passes = 2
    radius = 3
    noise = 0.02
    brightness = 0.9
    contrast = 0.9
    saturation = 1.1

    [colors]
    background = "${rgba p.bg "FF"}"
    text_primary = "${rgba p.fg "FF"}"
    text_muted = "${rgba p.fg_idle "FF"}"
    accent_primary = "${rgba p.accent "FF"}"
    accent_secondary = "${rgba p.accent2 "FF"}"
    warning = "${rgba p.yellow "FF"}"
    error = "${rgba p.red "FF"}"
    insert_hint = "${rgba p.accent "80"}"
    backdrop = "${rgba p.bg "FF"}"
    shadow = "${rgba p.black "7F"}"

    [colors.border]
    focused = "${rgba p.accent "FF"}"
    unfocused = "${rgba p.comment "FF"}"
    outer = "${rgba p.black "FF"}"

    [colors.overview]
    background_tint = "${rgba p.bg "30"}"
    workspace_background = "#00000044"
    badge = "${rgba p.accent "FF"}"

    [colors.tab_bar]
    background = "${rgba p.bg1 "FF"}"
    text = "${rgba p.fg_idle "FF"}"
    active = "${rgba p.accent "FF"}"
    active_text = "${rgba p.bg "FF"}"
    active_unfocused = "${rgba p.bg2 "FF"}"
    active_unfocused_text = "${rgba p.fg "FF"}"
    urgent = "${rgba p.red "FF"}"
    urgent_text = "${rgba p.bg "FF"}"

    [input.keyboard]
    numlock_toggle = true

    [input.focus]
    follows_mouse = false
    hover_raises = false

    [input.mouse]
    accel_profile = "flat"

    [input.cursor]
    theme = "Adwaita"
    size = 16

    [layout]
    gap = 4
    extent_presets = [0.333, 0.5, 0.667]

    [layout.scrolling]
    default_extent_fraction = 0.5
    # Keep the focused column where it is when picked from the overview,
    # so both halves stay visible like in niri.
    center_on_overview_select = false

    [keybinds]

    # Applications and session
    "Mod+Return" = { action = "spawn ghostty", repeat = false }
    "Mod+Space" = { action = "spawn noctalia msg panel-toggle launcher", repeat = false }
    "Mod+Q" = { action = "window-close", repeat = false }
    "Mod+Escape" = "session-quit"
    "Mod+Shift+Escape" = { action = "shortcuts-inhibit-toggle", allow_when_inhibited = true, repeat = false }

    # Media and brightness, routed through Noctalia so its OSDs show.
    "XF86AudioRaiseVolume" = { action = "spawn noctalia msg volume-up", allow_when_locked = true }
    "XF86AudioLowerVolume" = { action = "spawn noctalia msg volume-down", allow_when_locked = true }
    "XF86AudioMute" = { action = "spawn noctalia msg volume-mute", allow_when_locked = true, repeat = false }
    "XF86AudioPlay" = { action = "spawn playerctl play-pause", allow_when_locked = true, repeat = false }
    "XF86AudioPause" = { action = "spawn playerctl play-pause", allow_when_locked = true, repeat = false }
    "XF86AudioNext" = { action = "spawn playerctl next", allow_when_locked = true }
    "XF86AudioPrev" = { action = "spawn playerctl previous", allow_when_locked = true }
    "XF86MonBrightnessUp" = { action = "spawn noctalia msg brightness-up", allow_when_locked = true }
    "XF86MonBrightnessDown" = { action = "spawn noctalia msg brightness-down", allow_when_locked = true }

    # Screenshots and OCR
    "Print" = { action = "spawn screenshot-full", repeat = false }
    "Shift+Print" = { action = "spawn screenshot-region", repeat = false }
    "XF86Tools" = { action = "spawn screenshot-ocr", repeat = false }

    # Focus
    "Mod+Left" = "window-focus-left"
    "Mod+Down" = "window-focus-down"
    "Mod+Up" = "window-focus-up"
    "Mod+Right" = "window-focus-right"
    "Mod+H" = "window-focus-left"
    "Mod+J" = "window-focus-down"
    "Mod+K" = "window-focus-up"
    "Mod+L" = "window-focus-right"
    "Mod+F1" = "window-focus-next"
    "Mod+Shift+Left" = "column-move-left"
    "Mod+Shift+Right" = "column-move-right"
    "Mod+Shift+Up" = "window-move-up"
    "Mod+Shift+Down" = "window-move-down"

    # Window state and layout
    "Mod+V" = { action = "window-toggle-floating", repeat = false }
    "Mod+Shift+V" = { action = "window-focus-switch-floating", repeat = false }
    "Mod+P" = { action = "window-toggle-pinned", repeat = false }
    "Mod+F" = { action = "window-toggle-maximize", repeat = false }
    "Mod+Shift+F" = { action = "window-toggle-fullscreen", repeat = false }
    "Mod+M" = { action = "window-toggle-maximize-to-edges", repeat = false }
    "Mod+R" = "window-cycle-primary-extent"
    "Mod+Shift+R" = "window-cycle-primary-extent-back"
    "Mod+Minus" = "window-modify-primary-extent -0.02"
    "Mod+Equal" = "window-modify-primary-extent +0.02"
    "Mod+W" = { action = "column-toggle-tabbed", repeat = false }
    "Mod+O" = { action = "overview-toggle", repeat = false }
    "Mod+S" = { action = "spawn noctalia msg panel-toggle control-center", repeat = false }
    "Mod+Comma" = { action = "spawn noctalia msg settings-toggle", repeat = false }

    # Layouts: one per workspace, switchable at runtime.
    "Mod+Alt+1" = "workspace-set-layout scrolling"
    "Mod+Alt+2" = "workspace-set-layout dwindle"
    "Mod+Alt+3" = "workspace-set-layout master"
    "Mod+Alt+4" = "workspace-set-layout stacking"

    # Workspaces
    "Mod+1" = "workspace-switch 1"
    "Mod+2" = "workspace-switch 2"
    "Mod+3" = "workspace-switch 3"
    "Mod+4" = "workspace-switch 4"
    "Mod+5" = "workspace-switch 5"
    "Mod+6" = "workspace-switch 6"
    "Mod+7" = "workspace-switch 7"
    "Mod+8" = "workspace-switch 8"
    "Mod+9" = "workspace-switch 9"
    "Mod+Shift+1" = "window-move-to-workspace 1"
    "Mod+Shift+2" = "window-move-to-workspace 2"
    "Mod+Shift+3" = "window-move-to-workspace 3"
    "Mod+Shift+4" = "window-move-to-workspace 4"
    "Mod+Shift+5" = "window-move-to-workspace 5"
    "Mod+Shift+6" = "window-move-to-workspace 6"
    "Mod+Shift+7" = "window-move-to-workspace 7"
    "Mod+Shift+8" = "window-move-to-workspace 8"
    "Mod+Shift+9" = "window-move-to-workspace 9"
    # One window per scroll gesture instead of one per wheel notch.
    "Mod+WheelUp" = { action = "window-focus-left", cooldown_ms = 150 }
    "Mod+WheelDown" = { action = "window-focus-right", cooldown_ms = 150 }
    "Mod+Ctrl+WheelUp" = { action = "workspace-previous", cooldown_ms = 150 }
    "Mod+Ctrl+WheelDown" = { action = "workspace-next", cooldown_ms = 150 }

    # Scratchpad (drawer): mostrar/ocultar el pad Mod+D, guardar/sacar la ventana enfocada Mod+Ctrl+D
    "Mod+D" = { action = "scratchpad-toggle", repeat = false }
    "Mod+Ctrl+D" = { action = "window-toggle-scratchpad", repeat = false }

    [[window_rule]]
    blur = true

    [[window_rule]]
    match.app_id = "^dev[.]noctalia[.]Noctalia([.]Settings)?$"
    default_floating = true
    default_floating_size_px = { width = 1080, height = 920 }

    [[window_rule]]
    match.app_id = "^dev[.]noctalia[.]UmbrielSharePicker$"
    default_floating = true
    default_floating_size_px = { width = 800, height = 600 }

    [[window_rule]]
    match.title = "^(Picture-in-Picture|Picture in picture)$"
    default_floating = true
    default_maximize = false
    default_position = { x = 20, y = 20, anchor = "bottom_right" }

    [[window_rule]]
    match.title = "^notificationtoasts_.+_desktop"
    default_position = { x = 0, y = 0, anchor = "bottom_right" }
    default_focused = false
    default_pinned = true

    # Noctalia draws its own surfaces; bars and desktop widgets keep the cached
    # wallpaper blur, panels blur the live content behind them.
    [[layer_rule]]
    match.namespace = "^noctalia-"
    blur = true
    blur_ignore_alpha = 0.5
    blur_popups = true

    [[layer_rule]]
    match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)"
    blur_optimized = false

    [hot_corners.top_left]
    enabled = true
    delay_ms = 0
    action = "overview-toggle"

    [output.DP-3]
    mode = "3840x2160@120"

    [output.HDMI-A-1]
    mode = "3840x2160@120"
  '';
in
{
  imports = [
    ../../apps/home/noctalia.nix
    ../../apps/home/screenshots-wlr.nix
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "Polkit Authentication Agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = with pkgs; [
    kdePackages."kdeconnect-kde"
    kdePackages.qt6ct
    loupe
    adw-gtk3
    playerctl
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/nautilus/preferences" = {
        click-policy = "single";
        show-delete-permanently = true;
      };
    };
  };

  xdg.configFile."umbriel/config.toml".text = configToml;
}
