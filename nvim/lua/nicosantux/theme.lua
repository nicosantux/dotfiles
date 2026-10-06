local M = {}

local function persist(name)
	local path = vim.fn.stdpath("config") .. "/lua/current-theme.lua"
	vim.fn.writefile({ ('vim.cmd("colorscheme %s")'):format(name) }, path)
end

function M.pick()
	Snacks.picker.colorschemes({
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			picker.preview.state.colorscheme = nil
			vim.schedule(function()
				vim.cmd.colorscheme(item.text)
				persist(item.text)
			end)
		end,
	})
end

return M
