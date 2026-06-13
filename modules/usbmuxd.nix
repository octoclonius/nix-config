_: {
  flake.modules.nixos.usbmuxd =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            usbmuxd = {
              overrides = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            };
          };
        };
      };

      config = {
        services = lib.recursiveUpdate {
          usbmuxd = {
            enable = true;
          };
        } config.my.nixos.usbmuxd.overrides;
      };
    };
}
