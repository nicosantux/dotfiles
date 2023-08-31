vim.g.mapleader = " "

local keymap = vim.keymap

-- Quit insert mode
keymap.set("i", "jk", "<Esc>")

-- Move up or down the selection
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Move up a line and don't move the cursor
keymap.set("n", "J", "mzJ`z")

-- Navigating within the file with centered view
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Center the editor when move into selections
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Editor split view
keymap.set("n", "<leader>v", "<C-w>v")                       -- split window vertically
keymap.set("n", "<leader>h", "<C-w>s")                       -- split window horizontally
keymap.set("n", "<leader>e", "<C-w>=")                       -- make split windows equal width
keymap.set("n", "<leader>ww", "<cmd>close<CR>")              -- close current split window

keymap.set("n", "<leader>q", "<cmd>bdelete<CR>")             -- close current buffer
keymap.set("n", "<leader>qf", "<cmd>bdelete!<CR>")           -- force close current buffer
keymap.set("n", "<leader>p", "<cmd>BufferLineCyclePrev<CR>") -- go to previous buffer
keymap.set("n", "<leader>n", "<cmd>BufferLineCycleNext<CR>") -- go to next buffer

-- Editor tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")   -- open new tab
keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")     -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")     -- go to previous tab
