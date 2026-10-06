return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		config = function()
			local pattern = vim.fn.expand("~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua")
			local script = vim.fn.glob(pattern, false, true)[1]
			if script then
				dofile(script)
			else
				vim.notify("vim-herdr-navigation not found: " .. pattern, vim.log.levels.WARN)
			end
		end,
	},
	"nvim-lua/plenary.nvim",
}
