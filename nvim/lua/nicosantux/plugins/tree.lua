return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      sort_by = "case_sensitive",
      view = {
        width = 35,
        side = "right",
      },
      renderer = {
        group_empty = true,
      },
    })

    vim.keymap.set("n", "<leader>d", "<cmd>NvimTreeToggle<cr>")
    vim.keymap.set("n", "<leader>f", "<cmd>NvimTreeFocus<cr>")
  end
}
