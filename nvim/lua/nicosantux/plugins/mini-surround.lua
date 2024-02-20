return {
	"echasnovski/mini.surround",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		mappings = {
			add = "sa",
			delete = "sd",
			find = "sf",
			find_left = "sF",
			highlight = "sh",
			replace = "sr",
			update_n_lines = "sn",

			suffix_last = "l",
			suffix_next = "n",
		},
	},
}
