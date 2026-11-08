vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local keymap = vim.keymap

		opts.desc = "Show LSP references"
		keymap.set("n", "gr", Snacks.picker.lsp_references, opts)

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
		keymap.set("n", "gd", Snacks.picker.lsp_definitions, opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", Snacks.picker.lsp_implementations, opts)

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", Snacks.picker.lsp_type_definitions, opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)

		opts.desc = "Rename Symbol"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>K", Snacks.picker.diagnostics_buffer, opts)

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

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

vim.lsp.config("oxlint", {
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "oxlint.config.mts" })
		if root then
			on_dir(root)
		end
	end,
})

vim.lsp.config("vtsls", {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@astrojs/ts-plugin",
						location = vim.fn.stdpath("data") .. "/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
	},
})

vim.lsp.enable({
	"astro",
	"bashls",
	"cssls",
	"dockerls",
	"emmet_ls",
	"eslint",
	"html",
	"jsonls",
	"lua_ls",
	"oxlint",
	"prismals",
	"tailwindcss",
	"taplo",
	"vtsls",
	"yamlls",
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
	virtual_text = {
		format = function(diagnostic)
			if not diagnostic.source then
				return diagnostic.message
			end
			local code = diagnostic.code and (": " .. diagnostic.code) or ""
			return ("%s (%s%s)"):format(diagnostic.message, diagnostic.source, code)
		end,
	},
	underline = true,
	update_in_insert = false,
})
