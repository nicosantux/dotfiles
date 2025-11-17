vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local keymap = vim.keymap

		opts.desc = "Show LSP references"
		keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)

		opts.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)

		opts.desc = "Rename Symbol"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>K", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

		keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		-- vtsls-specific bindings
		if client ~= nil and client.name == "vtsls" then
			keymap.set("n", "<leader>oi", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.organizeImports" }, diagnostics = {} },
					apply = true,
				})
			end, { buffer = ev.buf, desc = "Organize Imports" })

			keymap.set("n", "<leader>ai", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
					apply = true,
				})
			end, { buffer = ev.buf, desc = "Add missing imports" })

			keymap.set("n", "<leader>ru", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.removeUnused" }, diagnostics = {} },
					apply = true,
				})
			end, { buffer = ev.buf, desc = "Remove unused imports" })
		end
	end,
})

vim.lsp.enable({
	"astro",
	"cssls",
	"emmet_ls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"tailwindcss",
	"vtsls",
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	virtual_text = true,
	underline = true,
	update_in_insert = false,
})
