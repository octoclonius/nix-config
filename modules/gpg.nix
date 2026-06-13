_: {
  flake.modules.homeManager.gpg =
    {
      config,
      lib,
      ...
    }:
    {
      options.my.home.gpg = {
        overrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
        publicKeySource = lib.mkOption {
          type = lib.types.path;
        };
      };

      config = {
        programs = {
          gpg = lib.recursiveUpdate {
            enable = true;
            mutableKeys = false;
            mutableTrust = false;
            publicKeys = [
              {
                source = config.my.home.gpg.publicKeySource;
                trust = "ultimate";
              }
            ];
          } config.my.home.gpg.overrides;
        };
      };
    };
}
