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

-- Select all
keymap.set("n", "<C-a>", "ggVG")

-- Center the editor when move into selections
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- New tab
keymap.set("n", "<C-t>", "<cmd>tabnew<CR>")
keymap.set("n", "<C-w>", "<cmd>bdelete<CR>")
keymap.set("n", "<tab>", "<cmd>BufferLineCycleNext<CR>")
keymap.set("n", "<s-tab>", "<cmd>BufferLineCyclePrev<CR>")

-- Editor split view
keymap.set("n", "<leader>v", "<C-w>v")
keymap.set("n", "<leader>h", "<C-w>s")
keymap.set("n", "<leader>e", "<C-w>=")
keymap.set("n", "<leader>ww", "<cmd>close<CR>")
