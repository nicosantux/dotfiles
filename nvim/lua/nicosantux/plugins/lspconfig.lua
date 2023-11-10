return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"jose-elias-alvarez/typescript.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{
			"smjonas/inc-rename.nvim",
			config = true,
		},
	},
	config = function()
		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local typescript = require("typescript")

		local keymap = vim.keymap

		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			keymap.set("n", "<leader>vws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			keymap.set("n", "<leader>k", function()
				vim.diagnostic.open_float()
			end, opts)
			keymap.set("n", "[d", function()
				vim.diagnostic.goto_next()
			end, opts)
			keymap.set("n", "]d", function()
				vim.diagnostic.goto_prev()
			end, opts)
			keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)
			keymap.set("n", "<leader>rr", function()
				vim.lsp.buf.references()
			end, opts)
			keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)
			-- typescript specific keymaps (e.g. rename file and update imports)
			if client.name == "tsserver" then
				keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
				keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports
				keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
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
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
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
