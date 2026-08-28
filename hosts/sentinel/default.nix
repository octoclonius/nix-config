{ config, inputs, ... }:
{
  hosts.nixos.sentinel = {
    modules = [
      ./_hardware-configuration.nix

      ({ lib, ... }: {
        boot = {
          loader = {
            efi = {
              canTouchEfiVariables = true;
            };
            systemd-boot = {
              enable = true;
              configurationLimit = 10;
            };
          };
        };

        fileSystems = {
          "/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
          };
          "/boot" = {
            device = "/dev/disk/by-label/EFI";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };

        my = {
          nixos = {
            primaryUser = "root";
            stateVersion = "26.11";
          };

          router = {
            ssh = {
              authorizedKeys = [
                (lib.fileContents (inputs.self + "/hosts/aegis/id_ed25519.pub"))
                (lib.fileContents (inputs.self + "/hosts/athena/id_ed25519.pub"))
              ];
            };
          };
        };

        networking = {
          hostName = "sentinel";
        };

        nix = {
          gc = {
            options = lib.mkForce "";
          };
        };

        time = {
          timeZone = "America/Chicago";
        };
      })
    ]
    ++ (with config.flake.modules.nixos; [
      routerAdguardhome
      routerDnscrypt
      routerFirewall
      routerNetwork
      routerOob
      routerOptions
      routerSsh
    ])
    ++ (with config.flake.modules.generic; [
      nix
      nixpkgs
      system
    ])
    ++ (with config.flake.modules.nixos; [
      base
    ]);

    system = "x86_64-linux";
  };
}
