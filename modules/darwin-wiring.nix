{
  config,
  inputs,
  lib,
  ...
}:
{
  flake = {
    darwinConfigurations = lib.mapAttrs (
      _: hostCfg:
      inputs.nix-darwin.lib.darwinSystem {
        inherit (hostCfg) modules system;
        specialArgs = {
          inherit inputs;
        };
      }
    ) (config.hosts.darwin or { });
  };
}
