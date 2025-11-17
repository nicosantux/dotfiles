return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
    version = "1.10.0",
		priority = 1000,
		opts = {
			flavour = "mocha",
			background = { light = "latte", dark = "mocha" },
			transparent_background = true,
      term_colors = true,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				keywords = { "italic" },
			},
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = {
					wave = {},
					dragon = {},
					all = {
						ui = {
							bg_gutter = "none",
							border = "rounded",
						},
					},
				},
			},
			overrides = function(colors) -- add/modify highlights
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					Pmenu = { fg = theme.ui.shade0, bg = "NONE", blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },

					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptBorder = { fg = theme.ui.special },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim },
					TelescopeResultsBorder = { fg = theme.ui.special },
					TelescopePreviewBorder = { fg = theme.ui.special },
				}
			end,
			theme = "wave", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
			},
		},
	},
  {
    "rose-pine/neovim",
		lazy = false,
		priority = 1000,
    name = "rose-pine",
    opts = {
      variant = "auto", -- auto, main, moon, or dawn
      dark_variant = "moon", -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
    },
  }
}
