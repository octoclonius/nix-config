_: {
  flake.modules.nixos.hardware-openrazer =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            hardware-openrazer = {
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
          openrazer = {
            enable = true;
            users = [
              config.my.nixos.primaryUser
            ];
          };
        } config.my.nixos.hardware-openrazer.overrides;
      };
    };
}
