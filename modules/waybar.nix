_: {
  flake.modules.homeManager.waybar =
    { config, lib, ... }:
    let
      primaryBackgroundOpacity = 0.5;
    in
    {
      options.my.home.waybar.overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      config = {
        programs = {
          waybar = lib.recursiveUpdate {
            enable = true;
            settings = {
              main = {
                clock = {
                  actions = {
                    on-click-right = "mode";
                    on-scroll-down = "shift_down";
                    on-scroll-up = "shift_up";
                  };
                  calendar = {
                    format = {
                      days = "<span color='#ecc6d9'><b>{}</b></span>";
                      months = "<span color='#ffead3'><b>{}</b></span>";
                      today = "<span color='#ff6699'><b><u>{}</u></b></span>";
                      weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                    };
                    mode = "month";
                    mode-mon-col = 3;
                    on-scroll = 1;
                  };
                  format = "{:%a %b %d %I:%M %p}";
                  tooltip-format = "<tt><small>{calendar}</small></tt>";
                };
                height = 18;
                modules-right = [
                  "clock"
                ];
                spacing = 0;
              };
            };
            style = ''
              * {
                box-shadow:none;
              }

              /* Transparent bar */
              window#waybar {
                background-color: rgba(0, 0, 0, ${builtins.toString primaryBackgroundOpacity});
                border: none;
              }

              /* Translucent background */
              #clock {
                font-family: monospace;
                padding: 0 3px;
              }
            '';
          } config.my.home.waybar.overrides;
        };
      };
    };
}
