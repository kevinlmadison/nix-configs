{
  programs.nixvim = {
    enable = true;

    colorschemes.ayu.enable = true;

    globals.mapleader = " ";

    options = {
      hlsearch = false;
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers

      shiftwidth = 2;        # Tab width should be 2
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      completeopt = "menuone,noselect";
      termguicolors = true;

    };

    highlight = {
      Comment.fg = "#ff00ff";
      Comment.bg = "#000000";
      Comment.underline = true;
      Comment.bold = true;
    };

    keymaps = [
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>g";
      }

      {
        mode = [ "n" "v" ];
        key = "<Space>";
        action = "<Nop>";
        options = {
	  silent = true;
	};
      }

      {
        mode = [ "n" ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
	  expr = true;
	  silent = true;
	};
      }

      {
        mode = [ "n" ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
	  expr = true;
	  silent = true;
	};
      }

      {
        mode = [ "n" ];
        key = "[d";
        action = "vim.diagnostic.goto_prev";
	lua = true;
        options = {
	  desc = "Go to previous diagnostic message";
	};
      }

      {
        mode = [ "n" ];
        key = "]d";
        action = "vim.diagnostic.goto_next";
	lua = true;
        options = {
	  desc = "Go to next diagnostic message";
	};
      }

      {
        mode = [ "n" ];
        key = "<leader>e";
        action = "vim.diagnostic.open_float";
	lua = true;
        options = {
	  desc = "Open floating diagnostic message";
	};
      }

      {
        mode = [ "n" ];
        key = "<leader>q";
        action = "vim.diagnostic.setloclist";
	lua = true;
        options = {
	  desc = "Open diagnostics list";
	};
      }

    ];

    autoGroups = {
      YankHighlight = {
	clear = true;
      };
    };

    autoCmd = [
      {
        event = ["TextYankPost"];
        callback = {__raw = "
	  function()
	    vim.highlight.on_yank()
	  end
	";};
        group = "YankHighlight";
        pattern = [ "*" ];
      }

      {
        event = ["BufEnter" "BufWinEnter"];
        pattern = [ "*.rs" ];
        command = "echo 'Entering a Rust file'";
      }
    ];

    plugins = { 

 #      alpha = {
	# enable = true;
 #      };
      bufferline.enable = true;
      dap.enable = true;
      cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-clippy.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      comment-nvim.enable = true;
      friendly-snippets.enable = true;
      indent-blankline.enable = true;
      luasnip.enable = true;
      navic.enable = true;
      nvim-autopairs.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      treesitter-textobjects.enable = true;
      ts-context-commentstring.enable = true;
      which-key.enable = true;

      lualine = {
	enable = true; 
	componentSeparators = {
	  left = "|";
	  right = "|";
	};
	sectionSeparators = {
	  left = "";
	  right = "";
	};
      };

      gitsigns = {
	enable = true;
	signs = {
	  add.text = "+";
	  change.text = "~";
	  delete.text = "_";
	  topdelete.text = "‾";
	  changedelete.text = "~";
	};
	onAttach.function = ''
	  function(bufnr)
	    local gs = package.loaded.gitsigns

	    local function map(mode, l, r, opts)
	      opts = opts or {}
	      opts.buffer = bufnr
	      vim.keymap.set(mode, l, r, opts)
	    end

	    -- Navigation
	    map({ 'n', 'v' }, ']c', function()
	      if vim.wo.diff then
		return ']c'
	      end
	      vim.schedule(function()
		gs.next_hunk()
	      end)
	      return '<Ignore>'
	    end, { expr = true, desc = 'Jump to next hunk' })

	    map({ 'n', 'v' }, '[c', function()
	      if vim.wo.diff then
		return '[c'
	      end
	      vim.schedule(function()
		gs.prev_hunk()
	      end)
	      return '<Ignore>'
	    end, { expr = true, desc = 'Jump to previous hunk' })

	    -- Actions
	    -- visual mode
	    map('v', '<leader>hs', function()
	      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
	    end, { desc = 'stage git hunk' })
	    map('v', '<leader>hr', function()
	      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
	    end, { desc = 'reset git hunk' })
	    -- normal mode
	    map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
	    map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
	    map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
	    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
	    map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
	    map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
	    map('n', '<leader>hb', function()
	      gs.blame_line { full = false }
	    end, { desc = 'git blame line' })
	    map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
	    map('n', '<leader>hD', function()
	      gs.diffthis '~'
	    end, { desc = 'git diff against last commit' })

	    -- Toggles
	    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
	    map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

	    -- Text object
	    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
	  end
	'';
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            desc = "file finder";
            action = "find_files";
          };
        };
        extensions = {
          file_browser.enable = true;
	  fzf-native.enable = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
	  ansiblels.enable = true;
	  bashls.enable = true;
	  yamlls.enable = true;
	  ruff-lsp.enable = true;
	  nushell.enable = true;
	  helm-ls.enable = true;
	  clangd.enable = true;
          nil_ls.enable = true;
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };
  };
}
      # cmp = {
      #   enable = true;
      #   autoEnableSources = true;
      #   # sources = [
      #   #   {name = "path";}
      #   #   {name = "buffer";}
      #   # ];
      #   # mapping = {
      #   #   "<CR>" = "cmp.mapping.confirm({ select = true })";
      #   #   "<Tab>" = {
      #   #     action = ''
      #   #       function(fallback)
      #   #         if cmp.visible() then
      #   #           cmp.select_next_item()
      #   #         elseif luasnip.expandable() then
      #   #           luasnip.expand()
      #   #         elseif luasnip.expand_or_jumpable() then
      #   #           luasnip.expand_or_jump()
      #   #         elseif check_backspace() then
      #   #           fallback()
      #   #         else
      #   #           fallback()
      #   #         end
      #   #       end
      #   #     '';
      #   #     modes = [ "i" "s" ];
      #   #   };
      #   # };
      # };
    # extraPlugins = with pkgs.vimPlugins; [
    #     {
    #       plugin = comment-nvim;
    #       config = ''lua require("Comment").setup()'';
    #     }
    # ];
