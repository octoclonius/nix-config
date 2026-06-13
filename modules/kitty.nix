_: {
  flake.modules.homeManager.kitty = { config, lib, ... }: {
    options.my.home.kitty.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        kitty = lib.recursiveUpdate {
          enable = true;
          settings = {
            background_opacity = 0.5;
            disable_ligatures = "always";
            enable_audio_bell = false;
          };
        } config.my.home.kitty.overrides;
      };
    };
  };
}
