return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    local kanagawa = require("kanagawa")

    kanagawa.setup({
      transparent = true,
    })
    -- load colorscheme
    vim.cmd([[colorscheme kanagawa]])
  end,
}
