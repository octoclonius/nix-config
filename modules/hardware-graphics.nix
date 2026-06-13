_: {
  flake.modules.nixos.hardware-graphics =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            hardware-graphics = {
              overrides = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            };
          };
        };
      };

      config = {
        hardware = lib.recursiveUpdate {
          graphics = {
            enable = true;
          };
        } config.my.nixos.hardware-graphics.overrides;
      };
    };
}
