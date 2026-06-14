{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
{
  imports = [
    inputs.niri.homeModules.niri
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

  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      niri
    ];
  };

  xdg.configFile."noctalia/config.toml".text = ''
    [shell]
    telemetry_enabled = false
    polkit_agent = false

    [shell.panel]
    attach_control_center = true
    attach_wallpaper = true

    [notification]
    enable_daemon = true
  '';

  home.packages = with pkgs; [
    kdePackages."kdeconnect-kde"
    loupe
    kdePackages.qt6ct
    adw-gtk3
  ];

  # Cursor: prefer declarative control via niri-flake/Home Manager.
  # DMS' settings UI doesn't reliably apply cursor changes live.
  programs.niri.settings.cursor = {
    theme = "Adwaita";
    size = 16;
  };

  # Enable Num Lock by default (niri input.keyboard.numlock).
  programs.niri.settings.input.keyboard.numlock = mkDefault true;

  # Focus follows mouse (hover-to-focus).
  programs.niri.settings.input.focus-follows-mouse.enable = mkDefault false;

  # Disable mouse acceleration.
  programs.niri.settings.input.mouse.accel-profile = mkDefault "flat";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Supervise Noctalia with systemd so it comes back after its known crashes.
  programs.niri.settings.spawn-at-startup = [ ];

  programs.niri.settings.binds = {
    "Ctrl+Space" = {
      hotkey-overlay.title = "Launcher";
      action.spawn = [ "vicinae" "toggle" ];
    };

    "Print".action.spawn = [
      "sh"
      "-c"
      ''
        mkdir -p "$HOME/Pictures"
        filename="$HOME/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"
        grim -g "$(slurp)" - | swappy -f - -o "$filename" && notify-send "Saved to $filename"
      ''
    ];

    "Ctrl+Print".action.spawn = [
      "sh"
      "-c"
      ''
        mkdir -p "$HOME/Pictures"
        filename="$HOME/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"
        grim "$filename" && notify-send "Saved to $filename"
      ''
    ];

    "Mod+F".action.maximize-column = [ ];
    "Mod+Shift+F".action.fullscreen-window = [ ];
    "Mod+V".action.toggle-window-floating = [ ];
    "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

    "Mod+S".action.spawn = [ "noctalia" "msg" "panel-toggle" "control-center" ];
    "Mod+Comma".action.spawn = [ "noctalia" "msg" "settings-toggle" ];

    "Mod+WheelScrollDown" = {
      cooldown-ms = 150;
      action.focus-column-right = [ ];
    };

    "Mod+WheelScrollUp" = {
      cooldown-ms = 150;
      action.focus-column-left = [ ];
    };

    "Mod+Ctrl+WheelScrollDown" = {
      cooldown-ms = 150;
      action.focus-workspace-down = [ ];
    };

    "Mod+Ctrl+WheelScrollUp" = {
      cooldown-ms = 150;
      action.focus-workspace-up = [ ];
    };

    "XF86AudioRaiseVolume".action.spawn = [ "noctalia" "msg" "volume-increase" ];
    "XF86AudioLowerVolume".action.spawn = [ "noctalia" "msg" "volume-decrease" ];
    "XF86AudioMute".action.spawn = [ "noctalia" "msg" "volume-mute-output" ];
    "XF86MonBrightnessUp".action.spawn = [ "noctalia" "msg" "raise-brightness" ];
    "XF86MonBrightnessDown".action.spawn = [ "noctalia" "msg" "lower-brightness" ];
  };

  programs.niri.settings.outputs."DP-3".mode = {
    width = 3840;
    height = 2160;
    refresh = 120.0;
  };

  programs.niri.settings.layout = {
    gaps = 4;
    border = {
      enable = true;
      width = 2;
      active.color = "#ffb1c8";
      inactive.color = "#9e8c90";
      urgent.color = "#ffb4ab";
    };
    focus-ring = {
      width = 2;
      active.color = "#ffb1c8";
      inactive.color = "#9e8c90";
      urgent.color = "#ffb4ab";
    };
  };

  programs.niri.settings.window-rules = [
    {
      geometry-corner-radius = {
        top-left = 15.0;
        top-right = 15.0;
        bottom-right = 15.0;
        bottom-left = 15.0;
      };
      clip-to-geometry = true;
    }
    {
      matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
      open-floating = true;
      default-column-width = { fixed = 1080; };
      default-window-height = { fixed = 920; };
    }
  ];

  programs.niri.settings.layer-rules = [
    {
      matches = [ { namespace = "^noctalia-backdrop"; } ];
      place-within-backdrop = true;
    }
  ];

  programs.niri.settings.debug.honor-xdg-activation-with-invalid-serial = [ ];

}
