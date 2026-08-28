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
          hostname = "sentinel";
          remoteBuild = true;
          profiles = {
            system = {
              sshUser = "root";
              user = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.sentinel;
            };
          };
        };
      };
    };
  };
}
