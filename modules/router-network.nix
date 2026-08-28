_: {
  flake.modules.nixos.routerNetwork =
    {
      config,
      lib,
      pkgs,
      utils,
      ...
    }:
    let
      cfg = config.my.router.network;
      wanDevice = "sys-subsystem-net-devices-${utils.escapeSystemdPath cfg.wanInterface}.device";
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
            after = [
              "network-pre.target"
              wanDevice
            ];
            before = [ "network.target" ];
            bindsTo = [ wanDevice ];
            description = "Disable hardware offloading on e1000e to prevent hangs";
            serviceConfig = {
              ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${cfg.wanInterface} gso off gro off tso off tx off rx off rxvlan off txvlan off sg off";
              RemainAfterExit = true;
              Type = "oneshot";
            };
            wantedBy = [ wanDevice ];
          };
        };
      };
    };
}
