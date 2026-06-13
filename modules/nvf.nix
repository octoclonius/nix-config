_: {
  flake.modules.homeManager.nvf =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.home.nvf = {
        languages = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "bash"
            "css"
            "html"
            "kotlin"
            "lua"
            "markdown"
            "nix"
            "python"
            "rust"
            "sql"
            "svelte"
            "terraform"
            "typescript"
            "yaml"
          ];
        };
        overrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
      };

      config = {
        programs = {
          nvf = lib.recursiveUpdate {
            enable = true;
            defaultEditor = true;
            enableManpages = true;
            settings = {
              vim = {
                autocomplete = {
                  nvim-cmp = {
                    enable = true;
                  };
                };
                autopairs = {
                  nvim-autopairs = {
                    enable = true;
                  };
                };
                binds = {
                  whichKey = {
                    enable = true;
                  };
                };
                extraPlugins = {
                  markdown-preview-nvim = {
                    package = pkgs.vimPlugins.markdown-preview-nvim;
                  };
                  vscode-nvim = {
                    package = pkgs.vimPlugins.vscode-nvim;
                    setup = ''
                      require('vscode').setup({
                        transparent = true,
                        underline_links = true,
                      })
                      vim.cmd.colorscheme "vscode"
                      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
                      vim.o.pumblend = 0
                      vim.cmd [[
                        highlight Pmenu guibg = none
                      ]]
                    '';
                  };
                };
                globals = {
                  mapleader = " ";
                };
                keymaps = [
                  {
                    action = ":Telescope find_files<CR>";
                    key = "<leader>ff";
                    mode = "n";
                    silent = true;
                  }
                  {
                    action = ":Telescope live_grep<CR>";
                    key = "<leader>fg";
                    mode = "n";
                    silent = true;
                  }
                  {
                    action = ":Telescope buffers<CR>";
                    key = "<leader>fb";
                    mode = "n";
                    silent = true;
                  }
                  {
                    action = ":Telescope commands<CR>";
                    key = "<leader>hc";
                    mode = "n";
                    silent = true;
                  }
                  {
                    action = ":Telescope help_tags<CR>";
                    key = "<leader>fh";
                    mode = "n";
                    silent = true;
                  }
                  {
                    action = ":MarkdownPreview<CR>";
                    key = "<leader>mp";
                    mode = "n";
                    silent = true;
                  }
                ];
                languages = lib.mkMerge [
                  {
                    enableExtraDiagnostics = true;
                    enableTreesitter = true;
                  }
                  (lib.genAttrs config.my.home.nvf.languages (_: {
                    enable = true;
                  }))
                ];
                lineNumberMode = "relNumber";
                lsp = {
                  enable = true;
                };
                luaConfigRC = {
                  extra = ''
                    vim.o.expandtab = true
                    vim.o.hlsearch = false
                    vim.o.mousescroll = "ver:1,hor:1"
                    vim.o.showmode = false
                  '';
                };
                options = {
                  shiftwidth = 0;
                  tabstop = 2;
                };
                statusline = {
                  lualine = {
                    enable = true;
                  };
                };
                syntaxHighlighting = true;
                telescope = {
                  enable = true;
                };
                viAlias = true;
                vimAlias = true;
                visuals = {
                  nvim-web-devicons = {
                    inherit (config.programs.nvf.settings.vim.statusline.lualine) enable;
                  };
                  rainbow-delimiters = {
                    enable = true;
                  };
                };
              };
            };
          } config.my.home.nvf.overrides;
        };
      };
    };
}
