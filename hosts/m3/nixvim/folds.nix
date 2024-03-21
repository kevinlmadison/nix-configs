{pkgs, ...}: {
programs.nixvim = {

  plugins.nvim-ufo = {
    enable = true;
    providerSelector = ''
      function(bufnr, filetype, buftype)
       			return { 'lsp', 'indent' }
       		end
    '';
  };
  extraConfigLua = ''
    -- Configuration for UFO folds
    require('ufo').setup({
    	provider_selector = function(bufnr, filetype, buftype)
    		return { 'lsp', 'indent' }
    	end
    })
    vim.keymap.set('n', 'zK', function()
    	local winid = require('ufo').peekFoldedLinesUnderCursor()
    	if not winid then
    		vim.lsp.buf.hover()
    	end
    end, { desc = "Pee[k] fold" })
  '';
  };
}
