return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			local languages = {
				"astro",
				"bash",
				"css",
				"dockerfile",
				"gitignore",
				"html",
				"http",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}

			ts.install(languages)

			ts.setup({
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = { enable = true },
				indent = { enable = true },
				ensure_installed = languages,
				auto_install = true,
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["ac"] = "@conditional.outer",
							["ic"] = "@conditional.inner",
							["a/"] = "@comment.outer",
							["i/"] = "@comment.inner",
						},
					},
				},
				additional_vim_regex_highlighting = false,
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local filetype = args.match
					local lang = vim.treesitter.language.get_lang(filetype)

					if lang and vim.treesitter.language.add(lang) then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
