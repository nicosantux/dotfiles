return {
	"mason-org/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_enable = false,
			-- servers for mason to install
			ensure_installed = {
				"astro",
				"cssls",
				"emmet_ls",
				"eslint",
				"html",
				"lua_ls",
				"tailwindcss",
				"vtsls",
				"jsonls",
				"yamlls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"eslint",
				"eslint_d",
				"markdown-toc",
				"prettier",
				"prettierd",
				"stylua",
			},
		})
	end,
}
