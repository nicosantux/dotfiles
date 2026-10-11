return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true })
			end,
			desc = "Find files in cwd",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Find files in buffers",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep({ hidden = true })
			end,
			desc = "Find string in cwd",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Find string under cursor in cwd",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word({ search = vim.fn.expand("<cWORD>") })
			end,
			desc = "Find Connected Words under cursor",
		},
		{
			"<leader>fgc",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Find commits",
		},
		{
			"<leader>fgb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Find branches",
		},
		{
			"<leader>fgs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Find changed files",
		},
		{
			"<leader>tt",
			function()
				Snacks.picker.todo_comments()
			end,
			desc = "Find todos",
		},
		{
			"<leader>ths",
			function()
				require("nicosantux.theme").pick()
			end,
			desc = "Theme Switcher",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Open LazyGit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Open LazyGit log",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
		},
	},
	opts = {
		indent = { animate = { enabled = false } },
		input = {},
		lazygit = {},
		picker = {
			layout = {
				preset = function()
					return vim.o.columns >= 120 and "telescope" or "vertical"
				end,
			},
			layouts = {
				telescope = {
					reverse = true,
					layout = {
						box = "horizontal",
						backdrop = false,
						width = 0.95,
						height = 0.95,
						border = "none",
						{
							box = "vertical",
							{ win = "list", title = " Results ", title_pos = "center", border = true },
							{ win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
						},
						{
							win = "preview",
							title = "{preview:Preview}",
							width = 0.6,
							border = true,
							title_pos = "center",
						},
					},
				},
				vertical = {
					layout = {
						backdrop = false,
						width = 0.9,
						min_width = 80,
						height = 0.95,
						min_height = 30,
						box = "vertical",
						border = true,
						title = "{title} {live} {flags}",
						title_pos = "center",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", height = 0.55, border = "top" },
					},
				},
			},
		},
		terminal = {},
		words = {},
	},
}
