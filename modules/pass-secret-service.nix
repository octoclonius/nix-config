_: {
  flake.modules.homeManager.pass-secret-service = { config, lib, ... }: {
    options.my.home.pass-secret-service.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      services = lib.recursiveUpdate {
        pass-secret-service = {
          enable = true;
        };
      } config.my.home.pass-secret-service.overrides;
    };
  };
}
