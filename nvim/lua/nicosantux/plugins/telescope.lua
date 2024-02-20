return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")

		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap

		keymap.set(
			"n",
			"<C-p>",
			"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>"
		)
		keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
		keymap.set("n", "<leader>pc", "<cmd>Telescope grep_string<cr>")
		keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>")
		keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>")
		keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
		keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>")
		keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
		keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")
	end,
}
