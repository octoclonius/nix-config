_: {
  flake.modules.homeManager.keepassxc = { config, lib, ... }: {
    options.my.home.keepassxc.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        keepassxc = lib.recursiveUpdate {
          enable = true;
        } config.my.home.keepassxc.overrides;
      };
    };
  };
}
