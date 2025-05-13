return {
	-- Mini Nvim
	{ "echasnovski/mini.nvim", version = false },
	-- Comments
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- disable the autocommand from ts-context-commentstring
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			require("mini.comment").setup({
				-- tsx, jsx, html , svelte comment support
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = "commentstring",
						}) or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	-- Surround
	{
		"echasnovski/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Add custom surroundings to be used on top of builtin ones. For more
			-- information with examples, see `:h MiniSurround.config`.
			custom_surroundings = nil,

			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 300,

			-- Module mappings. Use `''` (empty string) to disable one.
			-- INFO:
			-- saiw surround with no whitespace
			-- saw surround with whitespace
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			-- Number of lines within which surrounding is searched
			n_lines = 20,

			-- Whether to respect selection type:
			-- - Place surroundings on separate lines in linewise mode.
			-- - Place surroundings on each line in blockwise mode.
			respect_selection_type = false,

			-- How to search for surrounding (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
			-- see `:h MiniSurround.config`.
			search_method = "cover",

			-- Whether to disable showing non-error feedback
			silent = false,
		},
	},
	-- Split & join
	{
		"echasnovski/mini.splitjoin",
		config = function()
			local miniSplitJoin = require("mini.splitjoin")
			miniSplitJoin.setup({
				mappings = { toggle = "" }, -- Disable default mapping
			})
			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSplitJoin.join()
			end, { desc = "Join arguments" })
			vim.keymap.set({ "n", "x" }, "sk", function()
				miniSplitJoin.split()
			end, { desc = "Split arguments" })
		end,
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.ai").setup()
		end,
	},
}
