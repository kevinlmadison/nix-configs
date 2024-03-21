{pkgs, ...}: {
programs.nixvim = {

  colorschemes= {
		#tokyonight = {
		#	enable = true;
		#	style = "night";
		#	transparent = true;
		#};
		gruvbox = {
			enable = true;
			settings = {
				palette_overrides = {
					dark0 = "#000000";
					dark1 = "#141414";
					dark3 = "#3c3836";
				};
			};
		};
  };
  plugins = {
    # notify.enable = true;
    lualine = {
      enable = true;
      iconsEnabled = false;
      globalstatus = true;
      # theme = "onedark";
			componentSeparators = {
				left = "|";
				right = "|";
			};
			sectionSeparators = {
				left = "";
				right = "";
			};
    };
    # noice = {
    #   enable = true;
    #   presets = {
    #     bottom_search = true;
    #   };
    #   cmdline.format = {
    #     cmdline = {icon = ">";};
    #     search_down = {icon = "🔍⌄";};
    #     search_up = {icon = "🔍⌃";};
    #     filter = {icon = "$";};
    #     lua = {icon = "☾";};
    #     help = {icon = "?";};
    #   };
    #   format = {
    #     level = {
    #       icons = {
    #         error = "✖";
    #         warn = "▼";
    #         info = "●";
    #       };
    #     };
    #   };
    #   popupmenu = {
    #     kindIcons = false;
    #   };
    #   extraOptions = {
    #     inc_rename.cmdline.format.IncRename = {icon = "⟳";};
    #   };
    # };
  };
  # extraConfigLua = ''
  #   -- Noice recommended config
  #   require("noice").setup({
  #   lsp = {
  #   	override = {
  #   		["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  #   		["vim.lsp.util.stylize_markdown"] = true,
  #   		["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
  #   	},
  #   },
  #   })
  # '';
  };
}
