return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "smjonas/inc-rename.nvim", config = true },
	},
	config = function()
		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
		end
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Add rounded borders to hover
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})

		--  Set background color for floating windows
		vim.cmd([[ highlight NormalFloat guibg=#2a2a37 ]])

		-- Add rounded borders to diagnostics
		vim.diagnostic.config({
			virtual_text = false,
			float = {
				header = false,
				border = "rounded",
			},
		})

		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				local opts = { buffer = bufnr, remap = false }

				opts.desc = "Add Missing Imports"
				vim.keymap.set("n", "<leader>ai", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
						apply = true,
					})
				end, opts)

				opts.desc = "Organize Imports"
				keymap.set("n", "<leader>oi", function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
				end, opts)

				opts.desc = "Rename File"
				vim.keymap.set("n", "<leader>rf", function()
					local old_name = vim.api.nvim_buf_get_name(0)

					-- Prompt for new filename
					vim.ui.input({ prompt = "New filename: ", default = old_name }, function(new_name)
						-- Verifica si el nuevo nombre es válido
						if not new_name or new_name:gsub("^%s*(.-)%s*$", "%1") == "" or new_name == old_name then
							print("No changes made.")
							return
						end

						new_name = new_name:gsub("^%s*(.-)%s*$", "%1") -- Elimina espacios en blanco

						-- Rename the file
						local success, err = pcall(function()
							vim.fn.rename(old_name, new_name)
						end)

						if not success then
							print("Error renaming file: " .. err)
							return
						end

						-- Execute the LSP command to rename the file
						vim.lsp.buf.execute_command({
							command = "_typescript.applyRenameFile",
							arguments = {
								{
									sourceUri = vim.uri_from_fname(old_name),
									targetUri = vim.uri_from_fname(new_name),
								},
							},
						})

						-- Close the old named buffer
						vim.api.nvim_buf_delete(0, { force = true })

						-- Open the new named buffer
						vim.api.nvim_command(":e " .. new_name)
						print("Renamed file from " .. old_name .. " to " .. new_name)
					end)
				end, opts)

				opts.desc = "Remove unused imports"
				vim.keymap.set("n", "<leader>ru", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.removeUnusedImports.ts" }, diagnostics = {} },
						apply = true,
					})
				end, opts)
			end,
		})

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
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
