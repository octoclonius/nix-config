{
  config,
  inputs,
  ...
}:
let
  homeAspects = with config.flake.modules.homeManager; [
    bash
    direnv
    fonts
    gh
    git
    gpg
    gpg-agent
    gpg-import-sops
    gtk
    home
    hyprland
    hyprlock
    hyprpaper
    keepassxc
    kitty
    lazygit
    librewolf
    mcp
    mpv
    nvf
    opencode
    pass-secret-service
    password-store
    sops
    ssh
    state
    tofi
    waybar
    zsh
  ];
in
{
  hosts.nixos.aegis = {
    modules = [
      inputs.home-manager.nixosModules.home-manager

      ./_hardware-configuration.nix

      (
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          boot = {
            initrd = {
              luks = {
                devices = {
                  "luks-8e780eeb-341a-407b-a9a2-6daf0e66401e" = {
                    bypassWorkqueues = true;
                    device = "/dev/disk/by-uuid/8e780eeb-341a-407b-a9a2-6daf0e66401e";
                  };
                };
              };
            };
            loader = {
              efi = {
                canTouchEfiVariables = true;
              };
              systemd-boot = {
                enable = true;
              };
            };
          };

          my = {
            nixpkgs = {
              overrides = {
                config = {
                  allowUnfreePredicate =
                    pkg:
                    builtins.elem (lib.getName pkg) [
                      "osu-lazer-bin"
                      "steam"
                      "steam-unwrapped"
                    ];
                };
              };
            };
          };

          time = {
            timeZone = "America/Chicago";
          };

          users = {
            users = {
              ${config.my.nixos.primaryUser} = {
                isNormalUser = true;
                extraGroups = [
                  "networkmanager"
                  "wheel"
                ];
                shell = pkgs.zsh;
              };
            };
          };

          my = {
            nixos = {
              primaryUser = "octavius";
              stateVersion = "25.05";
            };
          };
        }
      )

      (
        {
          config,
          inputs,
          ...
        }:
        {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            users = {
              ${config.my.nixos.primaryUser} =
                {
                  inputs,
                  pkgs,
                  ...
                }:
                {
                  imports = homeAspects ++ [
                    inputs.nvf.homeManagerModules.default
                    inputs.sops-nix.homeManagerModules.sops
                  ];

                  my = {
                    home = {
                      extras = with pkgs; [
                        _7zz
                        ardour
                        blender
                        ffmpeg
                        gimp3-with-plugins
                        ifuse
                        kdePackages.kdenlive
                        libimobiledevice
                        nix-your-shell
                        nordzy-cursor-theme
                        osu-lazer-bin
                        polychromatic
                        signal-desktop
                        ungoogled-chromium
                        vlc
                        wl-clipboard
                        yt-dlp
                      ];

                      git = {
                        signingKey = "8A02F5D74BD4B098FFB171783EFB37773AACCEA7";
                        userEmail = "25781800+octoclonius@users.noreply.github.com";
                        userName = "octoclonius";
                      };

                      gpg = {
                        publicKeySource = inputs.self + "/keys/gpg.pub";
                      };

                      state = {
                        stateVersion = "25.05";
                      };
                    };

                    sops = {
                      defaultSopsFile = inputs.self + "/hosts/aegis/secrets.yaml";
                      secrets = {
                        "gpg" = { };
                      };
                    };
                  };
                };
            };
          };
        }
      )
    ]
    ++ (with config.flake.modules.nixos; [
      base
      greetd
      hardware-graphics
      hardware-openrazer
      hyprland
      hyprlock
      networking
      nix-ld
      steam
      usbmuxd
      zsh
    ])
    ++ (with config.flake.modules.generic; [
      nix
      nixpkgs
      system
    ]);

    system = "x86_64-linux";
  };
}
