return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"jose-elias-alvarez/typescript.nvim",
		{ "smjonas/inc-rename.nvim", config = true },
	},
	config = function()
		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local typescript = require("typescript")

		local keymap = vim.keymap

		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			opts.desc = "Go to definition"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

			opts.desc = "Go to references"
			keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts)

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			opts.desc = "Show available code actions"
			keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

			opts.desc = "Rename symbol"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

			opts.desc = "Show signature help"
			keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

			-- typescript specific keymaps (e.g. rename file and update imports)
			if client.name == "tsserver" then
				keymap.set("n", "<leader>ai", "<cmd>TypescriptAddMissingImports<cr>", { desc = "Add missing imports" })
				keymap.set(
					"n",
					"<leader>rf",
					"<cmd>TypescriptRenameFile<cr>",
					{ desc = "Rename file and update imports" }
				)
				keymap.set("n", "<leader>oi", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize imports" })
				keymap.set("n", "<leader>ru", "<cmd>TypescriptRemoveUnused<cr>", { desc = "Remove unused variables" })
			end
		end
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure typescript server with plugin
		typescript.setup({
			server = {
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "non-relative",
					},
				},
			},
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				tailwindCSS = {
					experimental = {
						classRegex = {
							{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						},
					},
				},
			},
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"css",
				"html",
				"javascript",
				"javascriptreact",
				"sass",
				"scss",
				"typescript",
				"typescriptreact",
			},
		})

		lspconfig["eslint"].setup({
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
}
