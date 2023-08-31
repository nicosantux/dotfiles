return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    local indent_blankline = require("indent_blankline")

    indent_blankline.setup({
      space_char_blankline = " ",
      show_current_context = true,
    })
  end
}
