return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			local languages = {
				"astro",
				"bash",
				"css",
				"diff",
				"dockerfile",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"html",
				"http",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"regex",
				"scss",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			ts.install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local filetype = args.match
					local lang = vim.treesitter.language.get_lang(filetype)

					if lang and vim.treesitter.language.add(lang) then
						if vim.treesitter.query.get(lang, "indents") then
							vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end
						vim.treesitter.start()
					end
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"xml",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
		},
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					html = {
						enable_close = true,
					},
					typescriptreact = {
						enable_close = true,
					},
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		---@module 'treesitter-modules'
		---@type ts.mod.UserConfig
		opts = {
			incremental_selection = {
				enable = true,
				disable = false,
				-- set value to `false` to disable individual mapping
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = false,
					node_decremental = false,
				},
			},
		},
	},
}
