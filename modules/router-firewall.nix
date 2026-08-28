_: {
  flake.modules.nixos.routerFirewall =
    { config, ... }:
    let
      cfg = config.my.router.network;
    in
    {
      boot = {
        kernel = {
          sysctl = {
            "net.ipv4.conf.all.accept_redirects" = 0;
            "net.ipv4.conf.all.rp_filter" = 1;
            "net.ipv4.conf.default.accept_redirects" = 0;
            "net.ipv4.conf.default.rp_filter" = 1;
            "net.ipv6.conf.all.accept_redirects" = 0;
            "net.ipv6.conf.default.accept_redirects" = 0;
          };
        };
      };

      networking = {
        firewall = {
          enable = false;
        };
        nftables = {
          enable = true;
          ruleset = ''
            table inet filter {
              chain input {
                type filter hook input priority 0; policy drop;

                iifname "lo" accept
                iifname "${cfg.lanBridge}" accept

                iifname "${cfg.wanInterface}" ct state invalid drop
                iifname "${cfg.wanInterface}" ct state established,related accept

                iifname "${cfg.wanInterface}" ip protocol icmp icmp type {
                  destination-unreachable,
                  parameter-problem,
                  time-exceeded
                } accept

                iifname "${cfg.wanInterface}" icmpv6 type {
                  destination-unreachable,
                  nd-neighbor-advert,
                  nd-neighbor-solicit,
                  nd-router-advert,
                  packet-too-big,
                  parameter-problem,
                  time-exceeded
                } accept

                iifname "${cfg.wanInterface}" udp dport 68 accept
                iifname "${cfg.wanInterface}" udp dport dhcpv6-client accept
              }

              chain forward {
                type filter hook forward priority 0; policy drop;

                ct state invalid drop
                ct state established,related accept

                iifname "${cfg.lanBridge}" oifname "${cfg.wanInterface}" accept
              }
            }

            table ip nat {
              chain postrouting {
                type nat hook postrouting priority 100; policy accept;

                oifname "${cfg.wanInterface}" masquerade
              }
            }
          '';
        };
      };
    };
}
