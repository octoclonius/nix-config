_: {
  flake.modules.nixos.greetd =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        my = {
          nixos = {
            greetd = {
              overrides = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
            };
          };
        };
      };

      config = {
        services = {
          greetd = lib.recursiveUpdate {
            enable = true;
            settings = {
              default_session = {
                command = "${
                  inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.tuigreet
                }/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/start-hyprland";
                user = "greeter";
              };
              initial_session = {
                command = "${pkgs.hyprland}/bin/start-hyprland";
                user = config.my.nixos.primaryUser;
              };
            };
          } config.my.nixos.greetd.overrides;
        };
      };
    };
}
