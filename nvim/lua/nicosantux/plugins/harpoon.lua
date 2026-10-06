return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = function()
		local function harpoon()
			return require("harpoon")
		end

		local keys = {
			{
				"<leader>ha",
				function()
					harpoon():list():add()
				end,
				desc = "Harpoon this file",
			},
			{
				"<leader>hd",
				function()
					harpoon():list():remove()
				end,
				desc = "Remove file from harpoon list",
			},
			{
				"<leader>he",
				function()
					harpoon().ui:toggle_quick_menu(harpoon():list())
				end,
				desc = "Show harpoon menu",
			},
			{
				"<leader>hp",
				function()
					harpoon():list():prev()
				end,
				desc = "Previous harpoon buffer",
			},
			{
				"<leader>hn",
				function()
					harpoon():list():next()
				end,
				desc = "Next harpoon buffer",
			},
		}

		for i = 1, 8 do
			keys[#keys + 1] = {
				"<leader>" .. i,
				function()
					harpoon():list():select(i)
				end,
				desc = "Select harpoon buffer " .. i,
			}
		end

		return keys
	end,
	config = function()
		require("harpoon"):setup({
			global_settings = {
				save_on_toggle = true,
				save_on_change = true,
			},
		})
	end,
}
