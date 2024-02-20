return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo = require("todo-comments")

		todo.setup({})

		vim.keymap.set("n", "<leader>tt", ":TodoTelescope<CR>", { noremap = true, silent = true })

		vim.keymap.set("n", "<leader>tn", function()
			todo.jump_next()
		end)

		vim.keymap.set("n", "<leader>tp", function()
			todo.jump_next()
		end)
	end,
}
