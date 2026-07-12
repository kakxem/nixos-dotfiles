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
        };

        animation.speed = 0.4;
      };

      notification.enable_daemon = true;

      bar.default = {
        start = [
          "launcher"
          "active_window"
        ];
        center = [
          "notifications"
          "clock"
          "media"
          "audio_visualizer"
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
      };

      dock = {
        enabled = true;
        auto_hide = true;
        launcher_position = "start";
        show_dots = true;
        reserve_space = false;
      };

      theme = {
        builtin = "Dracula";
        community_palette = "Catppuccin Lavender";
        templates.community_ids = [ "telegram" ];
      };
    };
  };
}
