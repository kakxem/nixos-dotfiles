#
#  Hyprland Home-manager configuration
#

{ pkgs, hyprland, user, ... }:

let
  hyprlandConf = ''
    ########################################################################################
    # AUTOGENERATED HYPR CONFIG.
    # PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
    # OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
    ########################################################################################

    #
    # Please note not all available settings / options are set here.
    # For a full list, see the wiki
    #

    #autogenerated = 1 # remove this line to remove the warning

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor=HDMI-A-1,3840x2160@120,auto,auto

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # Execute your favorite apps at launch
    exec-once = hyprpaper &
    exec-once = brave &
    exec-once = telegram-desktop &
    exec-once = vesktop &
    exec-once = swaync &
    exec-once = ulauncher --hide-window &

    # Source a file (multi-file configs)
    # source = ~/.config/hypr/myColors.conf

    # Some default env vars.
    env = XCURSOR_SIZE,24                            # Cursor size
    env = QT_QPA_PLATFORMTHEME,qt5ct                 # QT theme

    # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
    input {
        kb_layout = us
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1
        natural_scroll = 1
        accel_profile = flat

        touchpad {
	          natural_scroll = yes
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 5
        border_size = 0
        col.active_border = rgb(68C69E)
        col.inactive_border = rgba(595959aa)

        layout = dwindlr
    }

    decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10

        drop_shadow = yes
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    animations {
        enabled = yes

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        # new_is_master = true
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = on
    }

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    # device:epic-mouse-v1 {
    #     sensitivity = -0.5
    # }

    binds {
        allow_workspace_cycles = true
        workspace_back_and_forth = true
        scroll_event_delay = 100
    }

    misc {
        focus_on_activate = true
        vfr = false
    }

    # Example windowrule v1
    # windowrule = float, ^(kitty)$
    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more
    $mainMod = SUPER

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    bind = $mainMod, return, exec, alacritty
    bind = $mainMod, Q, killactive
    bind = $mainMod, F6, exit
    bind = $mainMod, E, exec, nautilus --new-window
    bind = $mainMod, V, togglefloating
    bind = $mainMod, F, fullscreen
    bind = CTRL, SPACE, exec, ulauncher
    bind = $mainMod, W, exec, firefox
    bind = $mainMod, P, pseudo # dwindle
    bind = $mainMod, J, togglesplit # dwindle

    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll (Only if one workspace is at right/left)
    bind = $mainMod, mouse_down, exec, bash /home/${user}/.config/nixos/modules/scripts/scroll-workspace.sh down
    bind = $mainMod, mouse_up, exec, bash /home/${user}/.config/nixos/modules/scripts/scroll-workspace.sh up

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:274, resizewindow

    # Screenshot
    bind=,print,exec,grim -g "$(slurp)" - | swappy -f - -o ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"

    # GTK Theme config
    exec-once = configure-gtk

    # Volume and Media Control
    bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
    bind = , XF86AudioLowerVolume, exec, pamixer -d 5
    bind = , XF86AudioMicMute, exec, pamixer --default-source -m
    bind = , XF86AudioMute, exec, pamixer -t
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioPause, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPrev, exec, playerctl previous

    # Hyprland screenshare
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  '';

  hyprpaperConf = ''
    preload = /home/${user}/.config/nixos/wallpapers/black.png
    wallpaper = ,/home/${user}/.config/nixos/wallpapers/black.png
  '';

in
{
  # Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = hyprlandConf;
  };
  xdg.configFile."hypr/hyprpaper.conf".text = hyprpaperConf;

  # Home packages
  home.packages = with pkgs; [
    # QT theme manager
    libsForQt5.qt5ct
    libsForQt5.breeze-qt5

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
      package = pkgs.libsForQt5.breeze-qt5;
      name = "Breeze";
    };
  };

  # USB mount
  services = {
    udiskie.enable = true;
  };
}
