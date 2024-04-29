return {
	"kylechui/nvim-surround",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				normal = "sa",
				normal_cur = "saa",
				normal_line = "sA",
				normal_cur_line = "sAA",
				delete = "sd",
				change = "sc",
				change_line = "sC",
			},
		})
	end,
}
