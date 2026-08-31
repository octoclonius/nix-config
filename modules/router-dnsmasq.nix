_: {
  flake.modules.nixos.routerDnsmasq =
    { config, ... }:
    let
      cfg = config.my.router.network;
      guestVlan = "br-lan.${toString cfg.guestVlanId}";
    in
    {
      services = {
        dnsmasq = {
          enable = true;
          resolveLocalQueries = false;
          settings = {
            dhcp-option = [
              "tag:guest,option:dns-server,${cfg.lanIp}"
              "tag:guest,option:router,${cfg.guestIp}"
              "tag:main,option:dns-server,${cfg.lanIp}"
              "tag:main,option:domain-name,${cfg.domain}"
              "tag:main,option:router,${cfg.lanIp}"
            ];
            dhcp-range = [
              "set:guest,${cfg.guestDhcpStart},${cfg.guestDhcpEnd},${cfg.guestMask},24h"
              "set:main,${cfg.dhcpStart},${cfg.dhcpEnd},${cfg.lanMask},24h"
            ];
            interface = [
              cfg.lanBridge
              guestVlan
            ];
            port = 0;
          };
        };
      };
    };
}
