_: {
  flake.modules.darwin.homebrew = { config, lib, ... }: {
    options.my.darwin.homebrew.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      homebrew = lib.recursiveUpdate {
        enable = true;
        brews = [ "gradle" ];
        casks = [
          "alt-tab"
          "anytype"
          "blender"
          "discord"
          "epic-games"
          "google-chrome"
          "ollama-app"
          "opencode-desktop"
          "sanesidebuttons"
          "steam"
          "syncthing-app"
          "unity-hub"
          "visual-studio-code@insiders"
          "vlc"
        ];
        onActivation = {
          cleanup = "zap";
        };
      } config.my.darwin.homebrew.overrides;
    };
  };
}
