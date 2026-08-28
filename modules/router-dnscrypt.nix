_: {
  flake.modules.nixos.routerDnscrypt =
    { config, ... }:
    let
      cfg = config.my.router.network;
    in
    {
      services = {
        dnscrypt-proxy = {
          enable = true;
          settings = {
            anonymized_dns = {
              routes = [
                {
                  server_name = "*";
                  via = [
                    "odohrelay-crypto-sx"
                    "odohrelay-numa"
                  ];
                }
              ];
            };

            dnscrypt_servers = false;
            doh_servers = false;

            listen_addresses = [
              cfg.dnscryptListenAddress
            ];

            odoh_servers = true;

            require_dnssec = true;
            require_nofilter = true;
            require_nolog = true;

            server_names = [
              "odoh-cloudflare"
            ];

            sources = {
              odoh-relays = {
                cache_file = "/var/lib/dnscrypt-proxy/odoh-relays.md";
                minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
                urls = [
                  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
                  "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
                ];
              };
              odoh-servers = {
                cache_file = "/var/lib/dnscrypt-proxy/odoh-servers.md";
                minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
                urls = [
                  "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
                  "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
                ];
              };
            };
          };
        };
      };

      systemd = {
        services = {
          dnscrypt-proxy = {
            after = [ "network-online.target" ];
            unitConfig = {
              StartLimitBurst = "20";
              StartLimitIntervalSec = "120";
            };
          };
        };
      };
    };
}
