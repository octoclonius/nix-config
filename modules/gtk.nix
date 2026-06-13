_: {
  flake.modules.homeManager.gtk = { config, lib, ... }: {
    options.my.home.gtk.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      dconf = lib.recursiveUpdate {
        enable = true;
        settings = {
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      } config.my.home.gtk.overrides;
      gtk = lib.recursiveUpdate {
        enable = true;
        gtk3 = {
          extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };
        };
      } config.my.home.gtk.overrides;
    };
  };
}
