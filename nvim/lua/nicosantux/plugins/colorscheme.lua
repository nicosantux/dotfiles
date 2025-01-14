return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "auto",
			background = { light = "latte", dark = "mocha" },
			transparent_background = true,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				keywords = { "italic" },
			},
		})

		vim.cmd([[colorscheme catppuccin]])
	end,
}
