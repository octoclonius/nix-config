_: {
  flake.modules.nixos.routerNetwork =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.router.network;
    in
    {
      boot = {
        kernel = {
          sysctl = {
            "net.ipv4.conf.all.forwarding" = 1;
            "net.ipv6.conf.all.forwarding" = 1;
          };
        };
      };

      networking = {
        networkmanager = {
          enable = lib.mkForce false;
        };
        useDHCP = false;
        useNetworkd = true;
      };

      systemd = {
        network = {
          enable = true;
          netdevs = {
            "20-${cfg.lanBridge}" = {
              netdevConfig = {
                Kind = "bridge";
                Name = cfg.lanBridge;
              };
            };
          };
          networks = {
            "10-wan" = {
              matchConfig = {
                Name = cfg.wanInterface;
              };
              networkConfig = {
                DHCP = "yes";
                IPv6AcceptRA = true;
              };
              linkConfig = {
                RequiredForOnline = "routable";
              };
            };
          }
          // (lib.listToAttrs (
            map (
              port:
              lib.nameValuePair "30-${port}" {
                matchConfig = {
                  Name = port;
                };
                networkConfig = {
                  Bridge = cfg.lanBridge;
                  ConfigureWithoutCarrier = true;
                };
                linkConfig = {
                  RequiredForOnline = "enslaved";
                };
              }
            ) cfg.lanPorts
          ))
          // {
            "40-${cfg.lanBridge}" = {
              matchConfig = {
                Name = cfg.lanBridge;
              };
              address = [
                "${cfg.lanIp}/${toString cfg.lanPrefixLength}"
              ];
              networkConfig = {
                ConfigureWithoutCarrier = true;
                IPv6AcceptRA = false;
              };
              linkConfig = {
                RequiredForOnline = "no";
              };
            };
          };
        };
        services = {
          e1000e-workaround = {
            description = "Disable hardware offloading on e1000e to prevent hangs";
            after = [ "network-pre.target" ];
            before = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${cfg.wanInterface} gso off gro off tso off tx off rx off rxvlan off txvlan off sg off";
            };
          };
        };
      };
    };
}
