_: {
  flake.modules.homeManager.gpg-import-sops =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.home.gpg-import-sops.overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      config = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isDarwin {
          home = {
            activation = {
              gpg-import-sops = lib.recursiveUpdate (lib.hm.dag.entryAfter [ "sops-nix" ] ''
                $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg --batch --import ${lib.escapeShellArg config.sops.secrets.gpg.path}
              '') config.my.home.gpg-import-sops.overrides;
            };
          };
        })

        (lib.mkIf pkgs.stdenv.isLinux {
          systemd = {
            user = {
              services = {
                gpg-import-sops = lib.recursiveUpdate {
                  Install = {
                    WantedBy = [ "default.target" ];
                  };
                  Service = {
                    ExecStart = "${pkgs.gnupg}/bin/gpg --batch --import ${config.sops.secrets.gpg.path}";
                    Type = "oneshot";
                  };
                  Unit = {
                    After = [ "sops-nix.service" ];
                    Description = "Import GPG key from sops-nix";
                    Requires = [ "sops-nix.service" ];
                  };
                } config.my.home.gpg-import-sops.overrides;
              };
            };
          };
        })
      ];
    };
}
