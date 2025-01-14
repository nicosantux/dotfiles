vim.g.mapleader = " "

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
keymap.set("n", "<C-a>", "ggVG")

-- Center the editor when move into selections
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Tabs
keymap.set("n", "<C-t>", "<cmd>tabnew<CR>", { desc = "Open a new tab" })
keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close tab" })
keymap.set("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Go to next tab" })
keymap.set("n", "<s-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Go to previous tab" })

-- Editor split view
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" })
