return {
	{
		"NickvanDyke/opencode.nvim",
		version = "*",
		dependencies = { "folke/snacks.nvim" },
		init = function()
			vim.g.opencode_opts = {}
			vim.o.autoread = true
		end,
		keys = {
			{
				"<leader>oa",
				function()
					require("opencode").ask("@this: ", { submit = true })
				end,
				mode = { "n", "x" },
				desc = "Ask opencode",
			},
			{
				"<leader>ox",
				function()
					require("opencode").select()
				end,
				mode = { "n", "x" },
				desc = "Execute opencode action…",
			},
			{
				"<leader>oA",
				function()
					require("opencode").prompt("@this")
				end,
				mode = { "n", "x" },
				desc = "Add to opencode",
			},
			{
				"<leader>oo",
				function()
					require("opencode").toggle()
				end,
				mode = { "n", "t" },
				desc = "Toggle opencode",
			},
			{
				"<leader>ou",
				function()
					require("opencode").command("session.half.page.up")
				end,
				desc = "opencode half page up",
			},
			{
				"<leader>od",
				function()
					require("opencode").command("session.half.page.down")
				end,
				desc = "opencode half page down",
			},
		},
	},
}
