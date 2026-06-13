_: {
  flake.modules.homeManager.password-store = { config, lib, ... }: {
    options.my.home.password-store.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        password-store = lib.recursiveUpdate {
          enable = true;
          settings = { };
        } config.my.home.password-store.overrides;
      };
    };
  };
}
