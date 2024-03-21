{pkgs, ...}: {
programs.nixvim = {
  plugins = {
    cmp = {
      enable = true;
      settings = {
      snippet.expand = "luasnip";
      mapping = {
        __raw = ''
      cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        })
        '';
        };
      window.documentation.border = [
        "╭"
        "─"
        "╮"
        "│"
        "╯"
        "─"
        "╰"
        "│"
      ];

      sources = {
        __raw = ''
          cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'cmdline' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'buffer' },
          })
        '';
      };      
      };
    };
    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-cmdline.enable = true;
    cmp-path.enable = true;
    luasnip.enable = true;
  };
  extraConfigLua = ''
    -- Extra options for cmp-cmdline setup
    local cmp = require("cmp")
    cmp.setup.cmdline(":", {
    	mapping = cmp.mapping.preset.cmdline(),
    	sources = cmp.config.sources({
    		{ name = "path" },
    	}, {
    		{
    			name = "cmdline",
    			option = {
    				ignore_cmds = { "Man", "!" },
    			},
    		},
    	}),
    })
  '';
  };
}
