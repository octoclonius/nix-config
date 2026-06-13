_: {
  flake.modules.homeManager.zsh = { config, lib, ... }: {
    options.my.home.zsh.overrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    config = {
      programs = {
        zsh = lib.recursiveUpdate {
          enable = true;
          autosuggestion = {
            enable = true;
            strategy = [
              "history"
              "match_prev_cmd"
            ];
          };
          enableCompletion = true;
          initContent = ''
            if command -v nix-your-shell > /dev/null; then
              nix-your-shell zsh | source /dev/stdin
            fi
          '';
          syntaxHighlighting = {
            enable = true;
          };
        } config.my.home.zsh.overrides;
      };
    };
  };

  flake.modules.nixos.zsh = {
    programs = {
      zsh = {
        enable = true;
      };
    };
  };
}
