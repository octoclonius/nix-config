_: {
  flake.modules.homeManager.state = { config, lib, ... }: {
    options.my.home.state = {
      overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
      };
    };

    config = {
      home = lib.recursiveUpdate {
        stateVersion = config.my.home.state.stateVersion;
      } config.my.home.state.overrides;
    };
  };
}
