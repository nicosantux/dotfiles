return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest",
	config = function()
		require("mcphub").setup({
			global_env = function()
				return {
					GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
					REPOSITORY_PATH = os.getenv("REPOSITORY_PATH"),
				}
			end,
		})
	end,
}
