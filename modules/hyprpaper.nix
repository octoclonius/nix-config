_: {
  flake.modules.homeManager.hyprpaper =
    { config, lib, ... }:
    {
      options.my.home.hyprpaper.overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      config = {
        services = {
          hyprpaper = lib.recursiveUpdate {
            inherit (config.wayland.windowManager.hyprland) enable;
            settings = {
              splash = false;
              wallpaper = [
                {
                  monitor = "";
                  path = "${config.xdg.userDirs.pictures}/wallpapers/bg.jpeg";
                }
              ];
            };
          } config.my.home.hyprpaper.overrides;
        };
      };
    };
}
