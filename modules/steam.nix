_: {
  flake.modules.nixos.steam =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            steam = {
              overrides = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            };
          };
        };
      };

      config = {
        programs = lib.recursiveUpdate {
          steam = {
            enable = true;
          };
        } config.my.nixos.steam.overrides;
      };
    };
}
