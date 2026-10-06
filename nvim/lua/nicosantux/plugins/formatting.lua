return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local eslint_config_files = {
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
		}

		conform.setup({
			formatters = {
				eslint_d = {
					condition = function(_, ctx)
						return vim.fs.find(eslint_config_files, { path = ctx.dirname, upward = true })[1] ~= nil
					end,
				},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
			},
			formatters_by_ft = {
				astro = { "eslint_d", "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				javascript = { "eslint_d", "prettierd" },
				javascriptreact = { "eslint_d", "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd", "markdown-toc" },
				mdx = { "prettierd", "markdown-toc" },
				typescript = { "eslint_d", "prettierd" },
				typescriptreact = { "eslint_d", "prettierd" },
				yaml = { "prettierd" },
			},
			format_on_save = {
				async = false,
				lsp_format = "fallback",
				timeout_ms = 3000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				async = false,
				lsp_format = "fallback",
				timeout_ms = 3000,
			})
		end, { desc = "Format document" })
	end,
}
