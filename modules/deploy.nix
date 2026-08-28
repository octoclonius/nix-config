{
  config,
  inputs,
  ...
}:
{
  flake = {
    deploy = {
      nodes = {
        sentinel = {
          hostname = config.flake.nixosConfigurations.sentinel.config.my.router.network.lanIp;
          profiles = {
            system = {
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.sentinel;
              sshUser = "root";
              user = "root";
            };
          };
          remoteBuild = true;
        };
      };
    };
  };
}
