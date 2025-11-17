return {
	"abecodes/tabout.nvim",
	event = "InsertEnter",
	config = function()
		require("tabout").setup({
			tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
			backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
			act_as_tab = true, -- shift content if tab out is not possible
			act_as_shift_tab = false, -- reverse shift content if tab out is not possible (only if act_as_tab is true)
			enable_backwards = true, -- enable backwards tabout
			completion = true, -- tabout will behave as normal tab in insert mode, only when no snippet is active
			tabouts = {
				{ open = "'", close = "'" },
				{ open = '"', close = '"' },
				{ open = "`", close = "`" },
				{ open = "(", close = ")" },
				{ open = "[", close = "]" },
				{ open = "{", close = "}" },
			},
			ignore_beginning = true, -- ignore tabout at the beginning of a line
			exclude = {}, -- list of filetypes to exclude tabout functionality
		})
	end,
}
