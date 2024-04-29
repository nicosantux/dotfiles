return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo = require("todo-comments")

		local keymap = vim.keymap

		keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { desc = "Find todos" })

		keymap.set("n", "<leader>tn", function()
			todo.jump_next()
		end, { desc = "Next todo comment" })

		keymap.set("n", "<leader>tp", function()
			todo.jump_next()
		end, { desc = "Previous todo comment" })

		todo.setup({})
	end,
}
