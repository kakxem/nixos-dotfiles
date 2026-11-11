#
#  Hyprland Home-manager configuration
#

{
  lib,
  pkgs,
  inputs,
  palette,
  palettes,
  ...
}:

let
  lua = lib.generators.mkLuaInline;
  # Palette color as Hyprland rgba(RRGGBBAA).
  c = hex: alpha: "rgba(${lib.removePrefix "#" hex}${alpha})";
  p = palettes.${palette};
  # The session runs the flake's Hyprland, so plugins must be built against it.
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  # Niri-like scrolling overview, built against the pinned Hyprland.
  scrolloverview = pkgs.callPackage ./plugins/scroll-overview.nix {
    inherit (pkgs.hyprlandPlugins) mkHyprlandPlugin;
    hyprland = hyprlandPkg;
  };
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
    ) 10
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
        "SUPER + SPACE"
        (lua ''hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")'')
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
        "SUPER + G"
        (lua ''
          function()
            hl.plugin.scrolloverview.overview("toggle all")
          end
        '')
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
        (lua ''hl.dsp.layout("focus r")'')
      ];
    }
    {
      _args = [
        "SUPER + mouse_up"
        (lua ''hl.dsp.layout("focus l")'')
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
        (lua ''hl.dsp.exec_cmd("screenshot-region")'')
      ];
    }
    {
      _args = [
        "SHIFT + PRINT"
        (lua ''hl.dsp.exec_cmd("screenshot-full")'')
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
        "XF86Tools"
        (lua ''hl.dsp.exec_cmd("screenshot-ocr")'')
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
  ]
  ++ workspaceBinds;

in
{
  imports = [
    ../../apps/home/noctalia.nix
    ../../apps/home/screenshots-wlr.nix
  ];

  # Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    plugins = [ scrolloverview ];
    settings = {
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "3840x2160@120";
          position = "auto";
          scale = "auto";
          bitdepth = 8;
        }
      ];

      env = [
        {
          _args = [
            "XCURSOR_SIZE"
            "24"
          ];
        }
        {
          _args = [
            "QT_QPA_PLATFORMTHEME"
            "qt5ct"
          ];
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("waycorner")
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
              -- systemd generates app-*@autostart units from ~/.config/autostart;
              -- the target is what starts them, as in Umbriel.
              hl.exec_cmd("systemctl --user start xdg-desktop-autostart.target")
              hl.exec_cmd("configure-gtk")
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
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.05
                ]
              ];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "default";
        }
      ];

      config = {
        input = {
          kb_layout = "us";
          # Focus follows the pointer, like niri, without re-focusing after a
          # keyboard focus change.
          follow_mouse = 1;
          mouse_refocus = false;
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
            active_border = c p.accent "ff";
            inactive_border = c p.comment "44";
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
        plugin.scrolloverview = {
          # wallpaper != 0 draws layer surfaces through the plugin and crashes
          # Hyprland with Noctalia's wallpaper (upstream #94).
          wallpaper = 0;
          blur = false;
          gesture_distance = 300;
          scale = 0.5;
          workspace_gap = 100;
          layout = "auto";
          shadow = {
            enabled = true;
            range = 50;
          };
        };
      };

      bind = hyprlandBinds;
    };

    # Hyprland workspaces only exist once created, and an empty one dies when you
    # leave it. Persistent rules keep 1-9 alive so the overview can show them and
    # accept drops.
    extraLuaFiles."workspaces" = lib.concatMapStringsSep "\n" (
      i: ''hl.workspace_rule({ workspace = "${toString i}", persistent = true })''
    ) (lib.range 1 9);
  };

  # Home packages
  home.packages = with pkgs; [
    # QT theme manager
    libsForQt5.qt5ct
    kdePackages.breeze

    # USB mount
    udiskie

    # Hot corners: enters the corner, toggles the overview
    waycorner
  ];

  # Hot corner in the top-left of every output
  xdg.configFile."waycorner/config.toml".text = ''
    [overview]
    enter_command = [ "hyprctl", "dispatch", "hl.plugin.scrolloverview.overview(\"toggle all\")" ]
    locations = [ "top_left" ]
    size = 8
    timeout_ms = 0
  '';

  # Color schema
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/nautilus/preferences" = {
        click-policy = "single";
        show-delete-permanently = true;
      };
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  # GTK styling comes from modules/config/theming/home.nix; defining it here
  # collides with that module (gtk.iconTheme.name).

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
