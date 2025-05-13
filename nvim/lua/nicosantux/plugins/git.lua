return {
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
				},
			})

			local keymap = vim.keymap

			keymap.set("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })
			keymap.set("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })
			keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
			keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Show file diff" })
			keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
			keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
			keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo hunk" })
			keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
			keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
			{ "<leader>gl", "<cmd>LazyGitLog<cr>", desc = "Open LazyGit" },
		},
	},
}
