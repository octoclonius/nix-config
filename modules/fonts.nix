_: {
  flake.modules.homeManager.fonts = { config, lib, ... }: {
    options.my.home.fonts.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      fonts = lib.recursiveUpdate {
        fontconfig = {
          enable = true;
        };
      } config.my.home.fonts.overrides;
    };
  };
}
