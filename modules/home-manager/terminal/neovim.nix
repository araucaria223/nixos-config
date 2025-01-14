{
  config,
  pkgs,
  lib,
  inputs,
  settings,
  ...
}: let
  cfg = config.neovim;
in {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.neovim = {
    enable = lib.my.mkDefaultTrueEnableOption ''
           Enable neovim -
      a powerful text editor
    '';
  };

  config = lib.mkIf cfg.enable {
    # shell alias
    programs.zsh.shellAliases = {v = "nvim";};

    stylix.targets.nixvim.enable = false;

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      colorschemes.${settings.colorScheme}.enable = true;

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      opts = {
        number = true;
        shiftwidth = 2;
        mouse = "";
      };

      extraConfigVim = ''
        " Trigger a highlight in the appropriate direction when pressing these keys:
        let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

        " Trigger a highlight only when pressing f and F.
        let g:qs_highlight_on_keys = ['f', 'F']
      '';

      autoGroups = {
        write_quit = {};
      };

      autoCmd = [
	{
	  event = ["InsertEnter"];
	  pattern = "*.yaml";
	  command = ":CloakPreviewLine";
	}
      ];

      keymaps = [
        {
          mode = "n";
          key = "j";
          action = "jzz";
        }
        {
          mode = "n";
          key = "n";
          action = "nzzzv";
        }
        {
          mode = "n";
          key = "k";
          action = "kzz";
        }
        {
          mode = "n";
          key = "<leader>fm";
          action = "<cmd>%!${lib.getExe pkgs.alejandra} -qq<CR>";
        }
        {
          mode = "n";
          key = "<leader>cp";
          action = ":CloakPreviewLine<CR>";
        }
        {
          mode = "n";
          key = "<leader>ct";
          action = ":CloakToggle<CR>";
        }
      ];

      globals.mapleader = ",";

      performance = {
        byteCompileLua = {
          enable = true;
          configs = true;
          initLua = true;
          nvimRuntime = true;
          plugins = true;
        };

        combinePlugins.enable = true;
      };

      plugins = {
        # status line
        lualine.enable = true;
        # shows indents
        indent-blankline.enable = true;
        # trims whitespace
        trim.enable = true;
        # startpage
        startify.enable = true;
        vim-surround.enable = true;

	# LaTeX
	vimtex.enable = true;

        # lsp for embedded code
        otter = {
          enable = true;
          settings.handle_leading_whitespace = true;
        };

        zen-mode = {
          enable = true;
          settings.plugins.twilight.enabled = true;
        };

        twilight = {
          enable = true;
          settings = {
            treesitter = true;
            expand = [
              "function"
              "method"
              "table"
              "if_statement"
            ];
          };
        };

        cloak = {
          enable = true;
          settings = {
            enabled = true;
	    cloak_character = "*";
            patterns = [
              {
                file_pattern = [
                  "*.yaml"
                ];

                cloak_pattern = [":.+"];
		replace = "[SECRET] %1";
              }
            ];
          };
        };

        treesitter = {
          enable = true;
          folding = false;
          nixvimInjections = true;
          nixGrammars = true;
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;

          settings = {
            highlight = {
              enable = true;
              additional_vim_regex_highlighting = true;
            };
            indent.enable = true;
          };
        };

        treesitter-context.enable = true;
	treesitter-textobjects.enable = true;
        cmp-treesitter.enable = true;

        lsp = {
          enable = true;

          servers = {
            lua_ls = {
              enable = true;
              settings.telemetry.enable = false;
            };

            nixd = {
              enable = true;
              autostart = true;
              settings = {
                nixpkgs.expr = "import <nixpkgs> { }";
                formatting.command = ["alejandra"];
              };
            };

            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };

	    yamlls.enable = true;

	    pyright.enable = true;
          };
        };

        lsp-format.enable = true;

        better-escape = {
          enable = true;
          settings = {
            timeout = 100;
          };
        };

        cmp = {
          enable = true;
          settings = {
            autoEnableSources = true;
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
              {name = "luasnip";}
              {name = "treesitter";}
            ];
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        quick-scope
      ];
    };
  };
}
