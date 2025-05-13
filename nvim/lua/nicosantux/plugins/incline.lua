return {
	"b0o/incline.nvim",
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local devicons = require("nvim-web-devicons")

		require("incline").setup({
			hide = {
				only_win = false,
			},
			render = function(props)
				local bufname = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(bufname, ":t")
				local display_name

				if filename == "" then
					display_name = "[No Name]"
				else
					local parent = vim.fn.fnamemodify(bufname, ":h:t")
					display_name = parent ~= "" and (parent .. "/" .. filename) or filename
				end

				local ext = vim.fn.fnamemodify(bufname, ":e")
				local icon, icon_color = devicons.get_icon(filename, ext, { default = true })

				local modified = vim.bo[props.buf].modified

				return {
					{ " ", icon, " ", guifg = icon_color },
					{ display_name, gui = modified and "bold" or "none" },
					modified and { " [+]", guifg = "#ff9e64" } or "",
					" ",
				}
			end,
		})
	end,
}
