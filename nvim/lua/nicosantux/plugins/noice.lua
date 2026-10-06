return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		cmdline = { enabled = true, view = "cmdline" },
		lsp = {
			progress = { enabled = true },
			signature = { enabled = false },
			-- override markdown rendering so that other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		views = {
			hover = { border = { style = "rounded" } },
		},
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = false, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
		},
	},
	keys = {
		{ "<leader>nt", "<cmd>Noice pick<cr>", desc = "Show Noice history" },
	},
}
