return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon this file" })

		keymap.set("n", "<leader>hd", function()
			harpoon:list():remove()
		end, { desc = "Remove file from harpoon list" })

		keymap.set("n", "<leader>he", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Show harpoon menu" })

		keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Select harpoon buffer 1" })

		keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Select harpoon buffer 2" })

		keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Select harpoon buffer 3" })

		keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Select harpoon buffer 4" })

		keymap.set("n", "<leader>5", function()
			harpoon:list():select(5)
		end, { desc = "Select harpoon buffer 5" })

		keymap.set("n", "<leader>6", function()
			harpoon:list():select(6)
		end, { desc = "Select harpoon buffer 6" })

		keymap.set("n", "<leader>7", function()
			harpoon:list():select(7)
		end, { desc = "Select harpoon buffer 7" })

		keymap.set("n", "<leader>8", function()
			harpoon:list():select(8)
		end, { desc = "Select harpoon buffer 8" })

		-- Toggle previous & next buffers stored within Harpoon list
		keymap.set("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Previous harpoon buffer" })
		keymap.set("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Next harpoon buffer" })
	end,
}
