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
      guestVlan = "br-lan.${toString cfg.guestVlanId}";
      wanDevice = "sys-subsystem-net-devices-${utils.escapeSystemdPath cfg.wanInterface}.device";
    in
    {
      boot = {
        kernel = {
          sysctl = {
            "net.ipv4.conf.all.forwarding" = 1;
            "net.ipv4.ip_nonlocal_bind" = 1;
            "net.ipv6.conf.all.forwarding" = 1;
            "net.ipv6.ip_nonlocal_bind" = 1;
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
              bridgeConfig = {
                VLANFiltering = true;
              };
              netdevConfig = {
                Kind = "bridge";
                Name = cfg.lanBridge;
              };
            };
            "21-${guestVlan}" = {
              netdevConfig = {
                Kind = "vlan";
                Name = guestVlan;
              };
              vlanConfig = {
                Id = cfg.guestVlanId;
              };
            };
          };
          networks = {
            "10-wan" = {
              dhcpV6Config = {
                PrefixDelegationHint = "::/64";
              };
              linkConfig = {
                RequiredForOnline = "routable";
              };
              matchConfig = {
                Name = cfg.wanInterface;
              };
              networkConfig = {
                DHCP = "yes";
                IPv6AcceptRA = true;
              };
            };
          }
          // (lib.listToAttrs (
            map (
              port:
              lib.nameValuePair "30-${port}" {
                bridgeVLANs = lib.optional (lib.elem port cfg.trunkPorts) { VLAN = cfg.guestVlanId; } ++ [
                  {
                    VLAN = cfg.mainVlanId;
                    PVID = cfg.mainVlanId;
                    EgressUntagged = cfg.mainVlanId;
                  }
                ];
                linkConfig = {
                  RequiredForOnline = "enslaved";
                };
                matchConfig = {
                  Name = port;
                };
                networkConfig = {
                  Bridge = cfg.lanBridge;
                  ConfigureWithoutCarrier = true;
                };
              }
            ) cfg.lanPorts
          ))
          // {
            "40-${cfg.lanBridge}" = {
              address = [
                "${cfg.lanIp}/${toString cfg.lanPrefixLength}"
                cfg.lanIpv6Address
              ];
              bridgeVLANs = [
                {
                  VLAN = cfg.mainVlanId;
                  PVID = cfg.mainVlanId;
                  EgressUntagged = cfg.mainVlanId;
                }
                { VLAN = cfg.guestVlanId; }
              ];
              ipv6Prefixes = [
                {
                  AddressAutoconfiguration = true;
                  OnLink = true;
                  Prefix = cfg.lanIpv6Prefix;
                }
              ];
              ipv6SendRAConfig = {
                DNS = [ (lib.replaceStrings [ "::/64" ] [ "::1" ] cfg.lanIpv6Prefix) ];
                EmitDNS = true;
              };
              linkConfig = {
                RequiredForOnline = "no";
              };
              matchConfig = {
                Name = cfg.lanBridge;
              };
              networkConfig = {
                ConfigureWithoutCarrier = true;
                DHCPPrefixDelegation = true;
                IPv6AcceptRA = false;
                IPv6SendRA = true;
              };
              vlan = [ guestVlan ];
            };
            "45-${guestVlan}" = {
              address = [ "${cfg.guestIp}/${toString cfg.guestPrefixLength}" ];
              linkConfig = {
                RequiredForOnline = "no";
              };
              matchConfig = {
                Name = guestVlan;
              };
              networkConfig = {
                ConfigureWithoutCarrier = true;
                IPv6AcceptRA = false;
                LinkLocalAddressing = "no";
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
