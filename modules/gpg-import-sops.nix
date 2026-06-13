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

      config = {
        launchd = {
          agents = {
            gpg-import-sops = lib.mkIf pkgs.stdenv.isDarwin (
              lib.recursiveUpdate {
                enable = true;
                config = {
                  ProgramArguments = [
                    "${pkgs.gnupg}/bin/gpg"
                    "--batch"
                    "--import"
                    "${config.sops.secrets.gpg.path}"
                  ];
                  RunAtLoad = true;
                };
              } config.my.home.gpg-import-sops.overrides
            );
          };
        };
        systemd = {
          user = {
            services = {
              gpg-import-sops = lib.mkIf pkgs.stdenv.isLinux (
                lib.recursiveUpdate {
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
                } config.my.home.gpg-import-sops.overrides
              );
            };
          };
        };
      };
    };
}
