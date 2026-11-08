vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- Quit insert mode
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Go to the start of the line
keymap.set("n", "H", "^", { desc = "Go to the start of the line" })

-- Go to the end of the line
keymap.set("n", "L", "$", { desc = "Go to the end of the line" })

-- Move up or down the selection
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down the selection" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up the selection" })

-- Move up a line and don't move the cursor
keymap.set("n", "J", "mzJ`z", { desc = "Move up a line and don't move the cursor" })

-- Navigating within the file with centered view
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Select all
keymap.set("n", "<leader>A", "ggVG", { desc = "Select all" })

-- Center the editor when move into selections
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Tabs
keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "Open a new tab" })
keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close tab" })
keymap.set("n", "<tab>", "<cmd>bnext<CR>", { desc = "Go to next tab" })
keymap.set("n", "<s-tab>", "<cmd>bprev<CR>", { desc = "Go to previous tab" })

-- Editor split view
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sp", "<cmd>vertical resize +10<CR>", { desc = "Increase vertical split" })
keymap.set("n", "<leader>sm", "<cmd>vertical resize -10<CR>", { desc = "Decrease vertical split" })
keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" })

-- Yank file path with line number
local function yank_path(modifier)
	local path = vim.fn.expand(modifier) .. "#L" .. vim.fn.line(".")
	vim.fn.setreg("+", path)
	vim.notify("Yanked: " .. path)
end

keymap.set("n", "<leader>yf", function()
	yank_path("%:.")
end, { desc = "Yank relative path with line number" })

keymap.set("n", "<leader>yp", function()
	yank_path("%:p")
end, { desc = "Yank absolute path with line number" })

-- Copy selection as a Markdown codeblock with filename and line number
local codeblock_langs = {
	typescriptreact = "tsx",
	javascriptreact = "jsx",
	typescript = "ts",
	javascript = "js",
}

keymap.set("x", "<leader>cc", function()
	local path = vim.fn.expand("%:.")
	if path == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	local first, last = vim.fn.line("v"), vim.fn.line(".")
	if first > last then
		first, last = last, first
	end

	local lang = codeblock_langs[vim.bo.filetype] or vim.bo.filetype
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
	local block = ('```%s filename="%s" line=%d\n%s\n```'):format(lang, path, first, table.concat(lines, "\n"))

	vim.fn.setreg("+", block)
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
	vim.notify("Copied " .. #lines .. " lines as codeblock")
end, { desc = "Copy selection as codeblock" })
