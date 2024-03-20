{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes = { 
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

    globals = { 
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      hlsearch = false;
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      expandtab = true;

      shiftwidth = 2; # Tab width should be 2
      tabstop = 2;
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

    extraConfigLua = ''
      local function find_git_root()
      -- Use the current buffer's path as the starting point for the git search
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      -- If the buffer is not associated with a file, return nil
      if current_file == "" then
        current_dir = cwd
      else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      -- Find the Git root directory from the current file's path
      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
           end

           -- Custom live_grep function to search in git root
      local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        require('telescope.builtin').live_grep {
          search_dirs = { git_root },
        }
      end
           end

           local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
           end

           -- [[ Configure LSP ]]
           --  This function gets run when an LSP connects to a particular buffer.
           local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
           end


           local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
           end
           require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
      ['<leader>h'] = { 'Git [H]unk' },
           }, { mode = 'v' })

           local capabilities = vim.lsp.protocol.make_client_capabilities()
           capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    '';

    keymaps = [
      {
        mode = ["n" "v"];
        key = "<Space>";
        action = "<Nop>";
        options = {
          silent = true;
        };
      }

      {
        mode = ["n"];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }

      {
        mode = ["n"];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }

      {
        mode = ["n"];
        key = "[d";
        action = "vim.diagnostic.goto_prev";
        lua = true;
        options = {
          desc = "Go to previous diagnostic message";
        };
      }

      {
        mode = ["n"];
        key = "]d";
        action = "vim.diagnostic.goto_next";
        lua = true;
        options = {
          desc = "Go to next diagnostic message";
        };
      }

      {
        mode = ["n"];
        key = "<leader>e";
        action = "vim.diagnostic.open_float";
        lua = true;
        options = {
          desc = "Open floating diagnostic message";
        };
      }

      {
        mode = ["n"];
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
        pattern = ["*"];
      }

      {
        event = ["BufEnter" "BufWinEnter"];
        pattern = ["*.rs"];
        command = "echo 'Entering a Rust file'";
      }
    ];
    userCommands = {
      LiveGrepGitRoot.command = "live_grep_git_root";
    };

    plugins = {
      bufferline.enable = true;
      dap.enable = true;
      cmp-buffer.enable = true;
      cmp-clippy.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      comment-nvim.enable = true;
      friendly-snippets.enable = true;
			fugitive.enable = true;
      indent-blankline.enable = true;
      luasnip.enable = true;
      navic.enable = true;
      nvim-autopairs.enable = true;
      oil.enable = true;
      ts-context-commentstring.enable = true;
      cmp = {
				enable = true;
				extraOptions = {
					completion = {
						completeopt = "menu,menuone,noinsert";
					};
					snippet = {
						expand = ''
						function(args)
							luasnip.lsp_expand(args.body)
						end
						'';
					};
				};
			};
      lazy = {
        enable = true;
    #     plugins = [
				# 	{
				# 		name = "fugitive";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "cmp";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "cmp-luasnip";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "cmp-nvim-lsp";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "cmp-path";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "friendly-snippets";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "which-key";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "gitsigns";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "lualine";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "indent-blankline";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "comment-nvim";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "telescope";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "treesitter";
				# 		enabled = true;
				# 	}
				#
				# 	{
				# 		name = "treesitter-textobjects";
				# 		enabled = true;
				# 	}
				#
				# ];
      };
      which-key = {
        enable = true;
        registrations = {
          "<leader>c" = {
            name = "[C]ode";
            _ = "which_key_ignore";
          };
          "<leader>d" = {
            name = "[D]ocument";
            _ = "which_key_ignore";
          };
          "<leader>g" = {
            name = "[G]it";
            _ = "which_key_ignore";
          };
          "<leader>h" = {
            name = "Git [H]unk";
            _ = "which_key_ignore";
          };
          "<leader>r" = {
            name = "[R]ename";
            _ = "which_key_ignore";
          };
          "<leader>s" = {
            name = "[S]earch";
            _ = "which_key_ignore";
          };
          "<leader>t" = {
            name = "[T]oggle";
            _ = "which_key_ignore";
          };
          "<leader>w" = {
            name = "[W]orkspace";
            _ = "which_key_ignore";
          };
        };
      };

      treesitter = {
        enable = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            initSelection = "<c-space>";
            nodeIncremental = "<c-space>";
            scopeIncremental = "<c-s>";
            nodeDecremental = "<M-space>";
          };
        };
      };

      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
          };
        };
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {
            "<leader>a" = "@parameter.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.inner";
          };
        };
      };

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
          "<leader>?" = {
            action = "oldfiles";
            desc = "[?] Find recently opened files";
          };

          "<leader><space>" = {
            action = "buffers";
            desc = "[ ] Find existing buffers";
          };

          "<leader>/" = {
            action = "function()
              require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
              })
            end";
            desc = "[/] Fuzzily search in current buffer";
          };

          "<leader>s/" = {
            action = "telescope_live_grep_open_files";
            desc = "[S]earch [/] in Open Files";
          };

          "<leader>ss" = {
            action = "builtin";
            desc = "[S]earch [S]elect Telescope";
          };

          "<leader>gf" = {
            action = "git_files";
            desc = "Search [G]it [F]iles";
          };

          "<leader>sf" = {
            action = "find_files";
            desc = "[S]earch [F]iles";
          };

          "<leader>sh" = {
            action = "help_tags";
            desc = "[S]earch [H]elp";
          };

          "<leader>sw" = {
            action = "grep_string";
            desc = "[S]earch current [W]ord";
          };

          "<leader>sg" = {
            action = "live_grep";
            desc = "[S]earch by [G]rep";
          };

          # "<leader>sG" = {
          #   action = ":LiveGrepGitRoot<cr>";
          #   desc = "[S]earch by [G]rep on Git Root";
          # };

          "<leader>sd" = {
            action = "diagnostics";
            desc = "[S]earch [D]iagnostics";
          };

          "<leader>sr" = {
            action = "resume";
            desc = "[S]earch [R]esume";
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
