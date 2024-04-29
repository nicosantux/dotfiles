return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			sort_by = "case_sensitive",
			view = {
				side = "right",
				width = 35,
			},
			renderer = {
				group_empty = true,
			},
		})

		-- keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>d", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>f", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file explorer" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<cr>", { desc = "Collapse all folders" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", { desc = "Refresh file explorer" })
	end,
}
