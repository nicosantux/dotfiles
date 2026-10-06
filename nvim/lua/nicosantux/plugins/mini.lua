return {
	"nvim-mini/mini.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	config = function()
		local ai = require("mini.ai")
		ai.setup({
			custom_textobjects = {
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				l = ai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
				c = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
				["/"] = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
			},
		})

		require("ts_context_commentstring").setup({ enable_autocmd = false })
		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring({
						key = "commentstring",
					}) or vim.bo.commentstring
				end,
			},
		})

		-- saiw surrounds without whitespace, saw with whitespace
		require("mini.surround").setup({ highlight_duration = 300 })

		local splitjoin = require("mini.splitjoin")
		splitjoin.setup({ mappings = { toggle = "" } })
		vim.keymap.set({ "n", "x" }, "sj", splitjoin.join, { desc = "Join arguments" })
		vim.keymap.set({ "n", "x" }, "sk", splitjoin.split, { desc = "Split arguments" })
	end,
}
