{ inputs, ... }:

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
        builtin = "Ayu";
        pure_black_dark = true;
      };

      audio = {
        enable_overdrive = true;
      };

      weather = {
        enabled = false;
      };
    };
  };
}
