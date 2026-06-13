_: {
  flake.modules.homeManager.zed = { config, lib, ... }: {
    options.my.home.zed.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        zed-editor = lib.recursiveUpdate {
          enable = true;
          enableMcpIntegration = true;
          mutableUserDebug = false;
          mutableUserKeymaps = false;
          mutableUserSettings = false;
          mutableUserTasks = false;
          userSettings = {
            telemetry = {
              auto_update = false;
              diagnostics = false;
              metrics = false;
            };
          };
        } config.my.home.zed.overrides;
      };
    };
  };
}
