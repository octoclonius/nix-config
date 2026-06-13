_: {
  flake.modules.nixos.networking =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            networking = {
              overrides = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            };
          };
        };
      };

      config = {
        networking = lib.recursiveUpdate {
          networkmanager = {
            enable = true;
          };
        } config.my.nixos.networking.overrides;
      };
    };
}
