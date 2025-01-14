return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		require("bufferline").setup({
			options = {
				always_show_bufferline = true,
				diagnostics = "nvim_lsp",
				indicator = { style = "icon", icon = "▎" },
				separator_style = { "", "" },
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		})
	end,
}
