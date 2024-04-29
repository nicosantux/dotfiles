return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			transparent = true,
		})

		vim.cmd([[colorscheme kanagawa]])
	end,
}
