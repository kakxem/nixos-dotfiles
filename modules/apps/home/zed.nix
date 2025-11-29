#
# Zed
#

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil # Nix LSP
    nixd # Nix LSP
  ];

  programs = {
    zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      userSettings = {
        autosave = "on_focus_change";
        bottom_dock_layout = "full";

        ui_font_family = "CaskaydiaCove Nerd Font";
        buffer_font_family = "CaskaydiaCove Nerd Font";
        ui_font_size = 21;
        buffer_font_size = 21;

        terminal = {
          font_family = "FiraCode Nerd Font";
        };

        icon_theme = "Material Icon Theme";
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark Pro";
        };

        tabs = {
          show_close_button = "hidden";
          file_icons = true;
          git_status = true;
        };

        sticky_scroll = {
          enabled = true;
        };

        inlay_hints = {
          enabled = true;
          show_background = true;
        };

        prettier = {
          allowed = false; # Nix files doesn't work with this... I'll investigate later
        };

        agent = {
          use_modifier_to_send = true;
          play_sound_when_agent_done = true;
          always_allow_tool_actions = true;
          default_profile = "write";
          default_model = {
            provider = "openrouter";
            model = "minimax/minimax-m2";
          };
          model_parameters = [ ];
        };
      };
    };
  };
}
