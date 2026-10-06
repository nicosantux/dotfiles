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
		dashboard = {
			preset = {
				header = [[
                 -*-           +-                 
                -***==         +**-               
             -+****===:        +****-             
            =+++***====-       +*****=            
            =++++**=====-.     +*****=            
            =++++++=======:    +*****=            
            =++++++.-======-   +*****=            
            =++++++..-======-. +*****=            
            =++++++.  :=======:+*****=            
            =++++++.   .-======+*****=            
            =++++++.    .-======+****=            
            =++++++.      :=====++***=            
             :+++++.       .-===++++=.            
               :+++.        .-==++=.              
                 :+.          :==.                ]],
				keys = {
					{ key = "e", icon = "\u{e5fe}", desc = "Toggle file explorer", action = "<cmd>NvimTreeToggle<CR>" },
					{ key = "f", icon = "\u{f0c7c}", desc = "Find File", action = function() Snacks.picker.files({ hidden = true }) end },
					{ key = "s", icon = "\u{f422}", desc = "Find Word", action = function() Snacks.picker.grep() end },
					{ key = "q", icon = "\u{f057}", desc = "Quit NVIM", action = "<cmd>qa<CR>" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
			},
		},
		indent = { animate = { enabled = false } },
		input = {},
		lazygit = {},
		picker = {
			layout = {
				preset = function()
					return vim.o.columns >= 120 and "telescope" or "vertical"
				end,
			},
		},
		terminal = {},
		words = {},
	},
}
