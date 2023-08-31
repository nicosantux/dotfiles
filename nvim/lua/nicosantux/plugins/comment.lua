return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup({
      toggler = {
        line = "]]"
      },
      opleader = {
        line = "]"
      }
    })
  end
}
