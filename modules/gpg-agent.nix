_: {
  flake.modules.homeManager.gpg-agent =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.home.gpg-agent.overrides = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      config = {
        services = {
          gpg-agent = lib.recursiveUpdate {
            enable = true;
            pinentry = {
              package = pkgs.pinentry-curses;
            };
          } config.my.home.gpg-agent.overrides;
        };
      };
    };
}
