return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local util = require("conform.util")

		conform.setup({
			formatters = {
				eslint_d = {
					cwd = util.root_file({
						"eslint.config.js",
						"eslint.config.mjs",
						"eslint.config.cjs",
						"eslint.config.ts",
						"eslint.config.mts",
						"eslint.config.cts",
					}),
					require_cwd = true,
				},
				oxlint = {
					cwd = util.root_file({ ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "oxlint.config.mts" }),
					require_cwd = true,
					-- A dot-prefixed temp file falls outside tsconfig's include, so type-aware fixes would strip needed `!`
					tmpfile_format = "conform.$RANDOM.$FILENAME",
				},
				oxfmt = {
					cwd = util.root_file({
						".oxfmtrc.json",
						".oxfmtrc.jsonc",
						"oxfmt.config.ts",
						"oxfmt.config.mts",
						"vite.config.ts",
						"vite.config.js",
					}),
					require_cwd = true,
				},
				prettierd = {
					condition = function(_, ctx)
						return not conform.get_formatter_info("oxfmt", ctx.buf).available
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
				astro = { "oxlint", "eslint_d", "oxfmt", "prettierd" },
				bash = { "shfmt" },
				css = { "oxfmt", "prettierd" },
				html = { "prettierd" },
				javascript = { "oxlint", "eslint_d", "oxfmt", "prettierd" },
				javascriptreact = { "oxlint", "eslint_d", "oxfmt", "prettierd" },
				json = { "oxfmt", "prettierd" },
				lua = { "stylua" },
				markdown = { "oxfmt", "prettierd", "markdown-toc" },
				mdx = { "oxfmt", "prettierd", "markdown-toc" },
				sh = { "shfmt" },
				toml = { "taplo" },
				typescript = { "oxlint", "eslint_d", "oxfmt", "prettierd" },
				typescriptreact = { "oxlint", "eslint_d", "oxfmt", "prettierd" },
				yaml = { "oxfmt", "prettierd" },
			},
			format_on_save = function(bufnr)
				if vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					async = false,
					lsp_format = "fallback",
					timeout_ms = 3000,
				}
			end,
		})

		vim.api.nvim_create_user_command("ToggleFormatter", function()
			local disabled = not vim.b.disable_autoformat
			vim.b.disable_autoformat = disabled
			vim.notify(
				"Format on save " .. (disabled and "disabled" or "enabled") .. " for this buffer",
				disabled and vim.log.levels.WARN or vim.log.levels.INFO
			)
		end, { desc = "Toggle format on save for current buffer" })

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				async = false,
				lsp_format = "fallback",
				timeout_ms = 3000,
			})
		end, { desc = "Format document" })
	end,
}
