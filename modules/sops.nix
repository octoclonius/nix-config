_: {
  flake.modules.homeManager.sops =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.sops = {
        defaultSopsFile = lib.mkOption {
          type = lib.types.path;
        };
        overrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
        secrets = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
        };
      };

      config = {
        home = {
          packages = with pkgs; [
            sops
          ];
        };

        sops = lib.recursiveUpdate {
          age = {
            keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          };
          defaultSopsFile = config.my.sops.defaultSopsFile;
          secrets = config.my.sops.secrets;
        } config.my.sops.overrides;
      };
    };
}
