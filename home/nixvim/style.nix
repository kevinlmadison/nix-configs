{...}: {
programs.nixvim = {

  colorschemes= {
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
    lualine = {
      enable = true;
      iconsEnabled = false;
      globalstatus = true;
			componentSeparators = {
				left = "|";
				right = "|";
			};
			sectionSeparators = {
				left = "";
				right = "";
			};
    };
  };
  };
}
