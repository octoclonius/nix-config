{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-parts.flakeModules.modules
    inputs.git-hooks-nix.flakeModule
    (inputs.import-tree ../hosts)
  ];

  flake-file = {
    inputs = {
      flake-file = {
        url = lib.mkDefault "github:vic/flake-file";
      };
      flake-parts = {
        url = lib.mkDefault "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs";
      };
      git-hooks-nix = {
        url = lib.mkDefault "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = lib.mkDefault "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      homebrew-cask = {
        flake = false;
        url = lib.mkDefault "github:homebrew/homebrew-cask";
      };
      homebrew-core = {
        flake = false;
        url = lib.mkDefault "github:homebrew/homebrew-core";
      };
      import-tree = {
        url = lib.mkDefault "github:vic/import-tree";
      };
      mac-app-util = {
        url = lib.mkDefault "github:hraban/mac-app-util";
      };
      nix-darwin = {
        url = lib.mkDefault "github:lnl7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nix-homebrew = {
        url = lib.mkDefault "github:zhaofengli-wip/nix-homebrew";
      };
      nixpkgs = {
        url = "github:nixos/nixpkgs/nixpkgs-unstable";
      };
      nur = {
        url = lib.mkDefault "github:nix-community/nur";
      };
      nvf = {
        url = lib.mkDefault "github:notashelf/nvf";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      sops-nix = {
        url = lib.mkDefault "github:mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      tuigreet = {
        url = lib.mkDefault "github:notashelf/tuigreet";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };

  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          packages = config.pre-commit.settings.enabledPackages;
          shellHook = config.pre-commit.shellHook;
        };
      };

      formatter = pkgs.nixfmt;

      pre-commit = {
        settings = {
          hooks = {
            deadnix = {
              enable = true;
              excludes = [ "_hardware-configuration\\.nix" ];
            };
            nixfmt = {
              enable = true;
              excludes = [ "_hardware-configuration\\.nix" ];
            };
            statix = {
              enable = true;
              settings = {
                ignore = [ "_hardware-configuration.nix" ];
              };
            };
          };
        };
      };
    };

  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
