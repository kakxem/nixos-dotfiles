#
#  Hyprland Home-manager configuration
#

{
  lib,
  pkgs,
  user,
  ...
}:

let
  lua = lib.generators.mkLuaInline;
  workspaceBinds = builtins.concatLists (
    builtins.genList (
      index:
      let
        workspace = builtins.toString (index + 1);
        key = if index == 9 then "0" else workspace;
      in
      [
        {
          _args = [
            "SUPER + ${key}"
            (lua "hl.dsp.focus({ workspace = ${workspace} })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + ${key}"
            (lua "hl.dsp.window.move({ workspace = ${workspace} })")
          ];
        }
      ]
    )
    10
  );
  hyprlandBinds = [
    {
      _args = [
        "SUPER + RETURN"
        (lua ''hl.dsp.exec_cmd("alacritty")'')
      ];
    }
    {
      _args = [
        "SUPER + Q"
        (lua "hl.dsp.window.close()")
      ];
    }
    {
      _args = [
        "SUPER + F6"
        (lua "hl.dsp.exit()")
      ];
    }
    {
      _args = [
        "SUPER + E"
        (lua ''hl.dsp.exec_cmd("nautilus --new-window")'')
      ];
    }
    {
      _args = [
        "SUPER + V"
        (lua ''hl.dsp.window.float({ action = "toggle" })'')
      ];
    }
    {
      _args = [
        "SUPER + F"
        (lua ''hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1")'')
      ];
    }
    {
      _args = [
        "SUPER + SHIFT + F"
        (lua ''hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0")'')
      ];
    }
    {
      _args = [
        "CTRL + SPACE"
        (lua ''hl.dsp.exec_cmd("vicinae toggle")'')
      ];
    }
    {
      _args = [
        "SUPER + W"
        (lua ''hl.dsp.exec_cmd("firefox")'')
      ];
    }
    {
      _args = [
        "SUPER + LEFT"
        (lua ''hl.dsp.focus({ direction = "left" })'')
      ];
    }
    {
      _args = [
        "SUPER + RIGHT"
        (lua ''hl.dsp.focus({ direction = "right" })'')
      ];
    }
    {
      _args = [
        "SUPER + H"
        (lua ''hl.dsp.focus({ direction = "left" })'')
      ];
    }
    {
      _args = [
        "SUPER + L"
        (lua ''hl.dsp.focus({ direction = "right" })'')
      ];
    }
    {
      _args = [
        "SUPER + UP"
        (lua ''hl.dsp.focus({ direction = "up" })'')
      ];
    }
    {
      _args = [
        "SUPER + DOWN"
        (lua ''hl.dsp.focus({ direction = "down" })'')
      ];
    }
    {
      _args = [
        "SUPER + mouse_down"
        (lua ''hl.dsp.layout("focus l")'')
      ];
    }
    {
      _args = [
        "SUPER + mouse_up"
        (lua ''hl.dsp.layout("focus r")'')
      ];
    }
    {
      _args = [
        "SUPER + CTRL + mouse_down"
        (lua ''hl.dsp.focus({ workspace = "+1" })'')
      ];
    }
    {
      _args = [
        "SUPER + CTRL + mouse_up"
        (lua ''hl.dsp.focus({ workspace = "-1" })'')
      ];
    }
    {
      _args = [
        "SUPER + mouse:272"
        (lua "hl.dsp.window.drag()")
        { mouse = true; }
      ];
    }
    {
      _args = [
        "SUPER + mouse:273"
        (lua "hl.dsp.window.resize()")
        { mouse = true; }
      ];
    }
    {
      _args = [
        "PRINT"
        (lua ''
          hl.dsp.exec_cmd([[sh -c 'filename="$HOME/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"; grim -g "$(slurp)" - | swappy -f - -o "$filename" && notify-send "Saved to $filename"']])
        '')
      ];
    }
    {
      _args = [
        "CTRL + PRINT"
        (lua ''
          hl.dsp.exec_cmd([[sh -c 'monitor="$(hyprctl activeworkspace | grep "^workspace ID" | cut -d" " -f6 | tr -d ":")"; filename="$HOME/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"; grim -o "$monitor" "$filename" && notify-send "Saved to $filename"']])
        '')
      ];
    }
    {
      _args = [
        "ALT + PRINT"
        (lua ''
          hl.dsp.exec_cmd([[sh -c 'at="$(hyprctl activewindow | grep "^at:" | cut -d" " -f2)"; size="$(hyprctl activewindow | grep "^size:" | cut -d" " -f2)"; filename="$HOME/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"; grim -g "$at $size" "$filename" && notify-send "Saved to $filename"']])
        '')
      ];
    }
    {
      _args = [
        "XF86AudioRaiseVolume"
        (lua ''hl.dsp.exec_cmd("pamixer -i 5")'')
      ];
    }
    {
      _args = [
        "XF86AudioLowerVolume"
        (lua ''hl.dsp.exec_cmd("pamixer -d 5")'')
      ];
    }
    {
      _args = [
        "XF86AudioMicMute"
        (lua ''hl.dsp.exec_cmd("pamixer --default-source -m")'')
      ];
    }
    {
      _args = [
        "XF86AudioMute"
        (lua ''hl.dsp.exec_cmd("pamixer -t")'')
      ];
    }
    {
      _args = [
        "XF86AudioPlay"
        (lua ''hl.dsp.exec_cmd("playerctl play-pause")'')
      ];
    }
    {
      _args = [
        "XF86AudioPause"
        (lua ''hl.dsp.exec_cmd("playerctl play-pause")'')
      ];
    }
    {
      _args = [
        "XF86AudioNext"
        (lua ''hl.dsp.exec_cmd("playerctl next")'')
      ];
    }
    {
      _args = [
        "XF86AudioPrev"
        (lua ''hl.dsp.exec_cmd("playerctl previous")'')
      ];
    }
  ] ++ workspaceBinds;

in
{
  # Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    settings = {
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "3840x2160@120";
          position = "auto";
          scale = "auto";
          bitdepth = 10;
          cm = "hdr";
          supports_wide_color = 1;
          supports_hdr = 1;
        }
      ];

      env = [
        { _args = [ "XCURSOR_SIZE" "24" ]; }
        { _args = [ "QT_QPA_PLATFORMTHEME" "qt5ct" ]; }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("vicinae server")
              hl.exec_cmd("noctalia")
              hl.exec_cmd("brave")
              hl.exec_cmd("telegram-desktop")
              hl.exec_cmd("vesktop")
              hl.exec_cmd("configure-gtk")
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            end
          '')
        ];
      };

      curve = [
        {
          _args = [
            "myBezier"
            {
              type = "bezier";
              points = [
                [ 0.05 0.9 ]
                [ 0.1 1.05 ]
              ];
            }
          ];
        }
      ];

      animation = [
        { leaf = "windows"; enabled = true; speed = 7; bezier = "myBezier"; }
        { leaf = "windowsOut"; enabled = true; speed = 7; bezier = "default"; style = "popin 80%"; }
        { leaf = "border"; enabled = true; speed = 10; bezier = "default"; }
        { leaf = "borderangle"; enabled = true; speed = 8; bezier = "default"; }
        { leaf = "fade"; enabled = true; speed = 7; bezier = "default"; }
        { leaf = "workspaces"; enabled = true; speed = 6; bezier = "default"; }
      ];

      config = {
        input = {
          kb_layout = "us";
          follow_mouse = 0;
          accel_profile = "flat";
          sensitivity = 0;
          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 4;
          gaps_out = 4;
          border_size = 2;
          col = {
            active_border = "rgb(ffb1c8)";
            inactive_border = "rgba(00000000)";
          };
          layout = "scrolling";
        };

        decoration = {
          rounding = 15;
        };
        animations = {
          enabled = true;
        };
        cursor = {
          no_warps = true;
        };
        binds = {
          allow_workspace_cycles = true;
          workspace_back_and_forth = true;
          pass_mouse_when_bound = false;
          scroll_event_delay = 100;
        };
        scrolling.wrap_focus = false;
        misc = {
          focus_on_activate = true;
        };
      };

      bind = hyprlandBinds;
      };
    };

  # Home packages
  home.packages = with pkgs; [
    # QT theme manager
    libsForQt5.qt5ct
    kdePackages.breeze
    vicinae

    # USB mount
    udiskie
  ];

  # Color schema
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  # GTK theme
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

  # QT theme
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze";
    };
  };

  # USB mount
  services = {
    udiskie.enable = true;
  };
}
