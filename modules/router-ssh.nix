_: {
  flake.modules.nixos.routerSsh =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.my.router.network;
    in
    {
      options = {
        my = {
          router = {
            ssh = {
              authorizedKeys = lib.mkOption {
                description = "SSH public keys allowed to log in as root on the router";
                type = lib.types.listOf lib.types.str;
              };
            };
          };
        };
      };

      config = {
        services = {
          openssh = {
            enable = true;
            listenAddresses = [
              {
                addr = cfg.lanIp;
                port = 22;
              }
              {
                addr = "127.0.0.1";
                port = 22;
              }
            ];
            settings = {
              PasswordAuthentication = false;
              PermitRootLogin = "prohibit-password";
              PubkeyAuthentication = true;
            };
          };
        };

        users = {
          users = {
            root = {
              openssh = {
                authorizedKeys = {
                  keys = config.my.router.ssh.authorizedKeys;
                };
              };
            };
          };
        };
      };
    };
}
