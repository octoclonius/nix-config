_: {
  flake.modules.nixos.nix-ld =
    { config, lib, ... }:
    {
      options = {
        my = {
          nixos = {
            nix-ld = {
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
          nix-ld = {
            enable = true;
          };
        } config.my.nixos.nix-ld.overrides;
      };
    };
}
