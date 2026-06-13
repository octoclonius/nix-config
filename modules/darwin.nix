_: {
  flake.modules.darwin.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.darwin = {
        overrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
        primaryUser = lib.mkOption {
          type = lib.types.str;
        };
        stateVersion = lib.mkOption {
          type = lib.types.int;
        };
      };

      config = {
        nix = {
          gc = {
            automatic = true;
            interval = {
              Hour = 3;
              Minute = 0;
              Weekday = 0;
            };
            options = "--delete-older-than 30d";
          };
          optimise = {
            automatic = true;
            interval = {
              Hour = 3;
              Minute = 0;
              Weekday = 0;
            };
          };
        };

        system = lib.recursiveUpdate {
          primaryUser = config.my.darwin.primaryUser;
          stateVersion = config.my.darwin.stateVersion;
        } (config.my.darwin.overrides.system or { });

        users = {
          users = {
            ${config.my.darwin.primaryUser} = lib.recursiveUpdate {
              home = "/Users/${config.my.darwin.primaryUser}";
              shell = pkgs.zsh;
            } (config.my.darwin.overrides.users.users.${config.my.darwin.primaryUser} or { });
          };
        };
      };
    };
}
