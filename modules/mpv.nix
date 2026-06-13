_: {
  flake.modules.homeManager.mpv = { config, lib, ... }: {
    options.my.home.mpv.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        mpv = lib.recursiveUpdate {
          enable = true;
        } config.my.home.mpv.overrides;
      };
    };
  };
}
