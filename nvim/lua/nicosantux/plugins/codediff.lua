return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{ "<leader>dd", "<cmd>CodeDiff<CR>", desc = "Toggle CodeDiff" },
		{ "<leader>dh", "<cmd>CodeDiff history %<CR>", desc = "File history (current file)" },
		{ "<leader>dH", "<cmd>CodeDiff history<CR>", desc = "File history (repo)" },
	},
	opts = {
		explorer = {
			view_mode = "tree",
			line_stats = { enabled = true },
		},
		diff = {
			compact = true,
			compact_context_lines = 8,
		},
	},
}
