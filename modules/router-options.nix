_: {
  flake.modules.nixos.routerOptions =
    { config, lib, ... }:
    let
      cfg = config.my.router.network;
    in
    {
      options = {
        my = {
          router = {
            network = {
              adguardPort = lib.mkOption {
                default = 3000;
                description = "Port for the AdGuard Home web UI (bound to localhost only)";
                type = lib.types.int;
              };

              dhcpEnd = lib.mkOption {
                default = "10.0.0.200";
                description = "Last IP address handed out by DHCP";
                type = lib.types.str;
              };

              dhcpStart = lib.mkOption {
                default = "10.0.0.100";
                description = "First IP address handed out by DHCP";
                type = lib.types.str;
              };

              dnscryptListenAddress = lib.mkOption {
                default = "127.0.0.1:${cfg.dnscryptPort}";
                description = "Address dnscrypt-proxy listens on and AdGuard Home uses as upstream";
                type = lib.types.str;
              };

              dnscryptPort = lib.mkOption {
                default = "5300";
                description = "Port dnscrypt-proxy listens on locally";
                type = lib.types.str;
              };

              domain = lib.mkOption {
                default = "home.arpa";
                description = "Local domain name for DHCP/DNS";
                type = lib.types.str;
              };

              lanBridge = lib.mkOption {
                default = "br-lan";
                description = "Name of the LAN bridge interface";
                type = lib.types.str;
              };

              lanIp = lib.mkOption {
                default = "10.0.0.1";
                description = "IP address of the router on the LAN bridge";
                type = lib.types.str;
              };

              lanMask = lib.mkOption {
                default = "255.255.255.0";
                description = "Subnet mask for the LAN";
                type = lib.types.str;
              };

              lanPorts = lib.mkOption {
                default = [
                  "enp1s0f0"
                  "enp1s0f1"
                  "enp1s0f2"
                  "enp1s0f3"
                ];
                description = "Physical interfaces that are part of the LAN bridge";
                type = lib.types.listOf lib.types.str;
              };

              lanPrefixLength = lib.mkOption {
                default = 24;
                description = "CIDR prefix length for the LAN subnet";
                type = lib.types.int;
              };

              wanInterface = lib.mkOption {
                default = "eno1";
                description = "Interface connected to the ISP/WAN";
                type = lib.types.str;
              };
            };
          };
        };
      };
    };
}
