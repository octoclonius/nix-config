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

        systemd = {
          services = {
            lanAddressReady = {
              after = [ "systemd-networkd.service" ];
              description = "Wait for the LAN bridge IPv4 address to be configured";
              requires = [ "systemd-networkd.service" ];
              serviceConfig = {
                ExecStart = "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --interface=${cfg.lanBridge}:off --ipv4";
                RemainAfterExit = true;
                Type = "oneshot";
              };
              wantedBy = [ "multi-user.target" ];
            };

            sshd = {
              after = [ "lanAddressReady.service" ];
              requires = [ "lanAddressReady.service" ];
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
