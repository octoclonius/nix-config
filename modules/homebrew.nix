_: {
  flake.modules.darwin.homebrew = { config, lib, ... }: {
    options.my.darwin.homebrew.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      homebrew = lib.recursiveUpdate {
        enable = true;
        brews = [
          "gradle"
          "krunkit"
          "podman"
        ];
        casks = [
          "alt-tab"
          "anytype"
          "blender"
          "discord"
          "opencode-desktop"
          "sanesidebuttons"
          "steam"
          "syncthing-app"
          "ungoogled-chromium"
          "visual-studio-code@insiders"
          "vlc@nightly"
        ];
        onActivation = {
          cleanup = "zap";
        };
      } config.my.darwin.homebrew.overrides;
    };
  };
}
