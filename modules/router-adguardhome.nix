_: {
  flake.modules.nixos.routerAdguardhome =
    { config, ... }:
    let
      cfg = config.my.router.network;
    in
    {
      services = {
        adguardhome = {
          enable = true;
          allowDHCP = true;
          host = cfg.lanIp;
          mutableSettings = false;
          openFirewall = false;
          port = cfg.adguardPort;
          settings = {
            dns = {
              bind_hosts = [
                cfg.lanIp
                "127.0.0.1"
              ];
              bootstrap_dns = [
                "9.9.9.9"
                "1.1.1.1"
                "2606:4700:4700::1111"
              ];
              port = 53;
              upstream_dns = [
                cfg.dnscryptListenAddress
              ];

              dhcp = {
                enabled = true;
                interface_name = cfg.lanBridge;
                local_domain_name = cfg.domain;
                dhcpv4 = {
                  gateway_ip = cfg.lanIp;
                  subnet_mask = cfg.lanMask;
                  range_start = cfg.dhcpStart;
                  range_end = cfg.dhcpEnd;
                  lease_duration = 86400;
                };
              };
            };

            filtering = {
              filtering_enabled = true;
              parental_enabled = false;
              protection_enabled = true;
              safe_search = {
                enabled = false;
              };
            };

            filters = [
              {
                enabled = true;
                name = "AdGuard DNS filter";
                url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
              }
              {
                enabled = true;
                name = "AdAway Default Blocklist";
                url = "https://adaway.org/hosts.txt";
              }
              {
                enabled = true;
                name = "The Big List of Hacked Malware Web Sites";
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
              }
              {
                enabled = true;
                name = "Malicious URL Blocklist";
                url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt";
              }
            ];

            querylog = {
              enabled = false;
            };

            statistics = {
              enabled = false;
            };
          };
        };
      };
    };
}
