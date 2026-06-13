{ config, inputs, ... }:
let
  homeAspects = with config.flake.modules.homeManager; [
    direnv
    gh
    git
    gpg
    gpg-agent
    gpg-import-sops
    home
    lazygit
    mcp
    nvf
    opencode
    sops
    ssh
    state
    zed
    zsh
  ];
in
{
  hosts.darwin.athena = {
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.mac-app-util.darwinModules.default
      inputs.nix-homebrew.darwinModules.nix-homebrew

      (
        { config, ... }:
        {
          networking = {
            computerName = config.networking.hostName;
            hostName = "athena";
          };

          nix-homebrew = {
            enable = true;
            mutableTaps = false;
            taps = {
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-core" = inputs.homebrew-core;
            };
            user = config.my.darwin.primaryUser;
          };

          homebrew = {
            taps = builtins.attrNames config.nix-homebrew.taps;
          };

          my = {
            darwin = {
              primaryUser = "octoclonius";
              stateVersion = 6;
            };

            nix = {
              overrides = {
                settings = {
                  trusted-users = [
                    "@admin"
                    "root"
                  ];
                };
              };
            };
          };
        }
      )

      (
        { config, ... }:
        {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            users = {
              ${config.my.darwin.primaryUser} =
                {
                  inputs,
                  pkgs,
                  ...
                }:
                {
                  imports = homeAspects ++ [
                    inputs.mac-app-util.homeManagerModules.default
                    inputs.nvf.homeManagerModules.default
                    inputs.sops-nix.homeManagerModules.sops
                  ];

                  my = {
                    home = {
                      extras = with pkgs; [
                        _7zz
                        ffmpeg
                        mkcert
                        rectangle
                        signal-desktop
                        yt-dlp
                      ];

                      git = {
                        signingKey = "DF3722D518C7611A70D4265E2DD114F68ED95212";
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
                      defaultSopsFile = inputs.self + "/hosts/athena/secrets.yaml";
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
    ++ (with config.flake.modules.darwin; [
      base
      homebrew
    ])
    ++ (with config.flake.modules.generic; [
      nix
      nixpkgs
      system
    ]);

    system = "aarch64-darwin";
  };
}
