_: {
  flake.modules.homeManager.hyprlock =
    { config, lib, ... }:
    {
      options.my.home.hyprlock.overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      config = {
        programs = {
          hyprlock = lib.recursiveUpdate {
            enable = true;
            settings = {
              animations = {
                enabled = false;
              };
              background = {
                color = "rgb(0, 0, 0)";
              };
              general = {
                hide_cursor = true;
                ignore_empty_input = true;
              };
              input-field = {
                fade_timeout = 1500;
                fail_text = "";
                hide_input = true;
                inner_color = config.programs.hyprlock.settings.background.color;
                outer_color = config.programs.hyprlock.settings.background.color;
                outline_thickness = 16;
                placeholder_text = "";
                size = "128, 128";
              };
            };
          } config.my.home.hyprlock.overrides;
        };
      };
    };

  flake.modules.nixos.hyprlock = {
    security = {
      pam = {
        services = {
          hyprlock = {
            enable = true;
          };
        };
      };
    };
  };
}
