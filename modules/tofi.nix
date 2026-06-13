_: {
  flake.modules.homeManager.tofi = { config, lib, ... }: {
    options.my.home.tofi.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        tofi = lib.recursiveUpdate {
          enable = true;
        } config.my.home.tofi.overrides;
      };
    };
  };
}
