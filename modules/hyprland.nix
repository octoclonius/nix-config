_: {
  flake.modules.homeManager.hyprland = {
    wayland = {
      windowManager = {
        hyprland = {
          enable = true;
          configType = "hyprlang";
          package = null;
          portalPackage = null;
          settings = {
            "$fileManager" = "nnn";
            "$lock" = "hyprlock";
            "$menu" = "tofi-drun --drun-launch=true";
            "$mod" = "ALT";
            "$terminal" = "kitty";
            animations = {
              enabled = false;
            };
            bind = [
              "$mod CTRL, DELETE, exec, $lock"
              "$mod, E, exec, $fileManager"
              "$mod, H, movefocus, l"
              "$mod, J, movefocus, d"
              "$mod, K, movefocus, u"
              "$mod, L, movefocus, r"
              "$mod, M, exit,"
              "$mod, O, layoutmsg, togglesplit"
              "$mod, Q, killactive,"
              "$mod, S, togglespecialworkspace, magic"
              "$mod, SPACE, exec, $menu"
              "$mod, V, togglefloating,"
              "$mod, RETURN, exec, $terminal"
              "$mod SHIFT, S, movetoworkspace, special:magic"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${builtins.toString i}, workspace, ${builtins.toString ws}"
                  "$mod SHIFT, code:1${builtins.toString i}, movetoworkspace, ${builtins.toString ws}"
                ]
              ) 9
            ));
            binde = [
              "$mod SHIFT, H, resizeactive, -10 0"
              "$mod SHIFT, J, resizeactive, 0 10"
              "$mod SHIFT, K, resizeactive, 0 -10"
              "$mod SHIFT, L, resizeactive, 10 0"
            ];
            bindel = [
              ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
              ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
            ];
            bindl = [
              ", XF86AudioNext, exec, playerctl next"
              ", XF86AudioPause, exec, playerctl play-pause"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioPrev, exec, playerctl previous"
            ];
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];
            debug = {
              disable_logs = false;
              disable_time = false;
              enable_stdout_logs = true;
            };
            decoration = {
              blur = {
                enabled = true;
                passes = 2;
                size = 2;
              };
              shadow = {
                enabled = false;
              };
            };
            dwindle = {
              preserve_split = true;
            };
            ecosystem = {
              no_donation_nag = true;
              no_update_news = true;
            };
            env = [
              "HYPRCURSOR_THEME, Nordzy-cursors"
            ];
            exec-once = [
              "waybar"
            ];
            general = {
              border_size = 0;
              gaps_in = 0;
              gaps_out = 0;
              resize_on_border = true;
            };
            gesture = "3, horizontal, workspace";
            input = {
              accel_profile = "flat";
              follow_mouse = 1;
              kb_layout = "us";
              natural_scroll = true;
              scroll_points = "";
              sensitivity = 0;
            };
            layerrule = [
              "blur on, match:namespace waybar"
            ];
            master = {
              new_status = "master";
            };
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
            };
            monitor = ", 3840x2160, auto, auto";
            windowrule = [
              "match:class ^$, match:title ^$, match:xwayland true, float on, fullscreen off, pin off, no_focus on"
              "match:class .*, suppress_event maximize"
            ];
          };
        };
      };
    };
  };

  flake.modules.nixos.hyprland = {
    programs = {
      hyprland = {
        enable = true;
      };
    };
  };
}
