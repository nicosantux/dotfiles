vim.g.mapleader = " "

-- Quit insert mode
vim.keymap.set("i", "jk", "<Esc>")

-- Move up or down the selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move up a line and don't move the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Navigating within the file with centered view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center the editor when move into selections
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Editor split view
vim.keymap.set("n", "<leader>v", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s") -- split window horizontally
vim.keymap.set("n", "<leader>e", "<C-w>=") -- make split windows equal width
vim.keymap.set("n", "<leader>ww", "<cmd>close<CR>") -- close current split window

vim.keymap.set("n", "<leader>q", "<cmd>bdelete<CR>") -- close current buffer
vim.keymap.set("n", "<leader>qf", "<cmd>bdelete!<CR>") -- force close current buffer
vim.keymap.set("n", "<leader>p", "<cmd>BufferLineCyclePrev<CR>") -- go to previous buffer
vim.keymap.set("n", "<leader>n", "<cmd>BufferLineCycleNext<CR>") -- go to next buffer

-- Editor tabs
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>") -- open new tab
vim.keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>") -- go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>") -- go to previous tab

-- NTree
vim.keymap.set("n", "<leader>d", "<cmd>NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>NvimTreeFocus<cr>")

-- Telescope
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>pc", "<cmd>Telescope grep_string<cr>")
vim.keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>")
