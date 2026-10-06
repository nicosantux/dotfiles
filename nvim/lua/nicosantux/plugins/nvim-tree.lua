return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle", "NvimTreeFocus", "NvimTreeCollapse", "NvimTreeRefresh" },
	keys = {
		{ "<leader>ee", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle file explorer" },
		{ "<leader>ef", "<cmd>NvimTreeFocus<cr>", desc = "Focus file explorer" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<cr>", desc = "Collapse all folders" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh file explorer" },
	},
	opts = {
		sort_by = "case_sensitive",
		view = { side = "right", width = 50 },
		renderer = { group_empty = true },
	},
}
