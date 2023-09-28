return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")

    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,                 -- move to prev result
            ["<C-j>"] = actions.move_selection_next,                     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap

    keymap.set(
      "n",
      "<C-p>",
      "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>"
    )
    keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
    keymap.set("n", "<leader>pc", "<cmd>Telescope grep_string<cr>")
    keymap.set("n", "<leader>pb", "<cmd>Telescope buffers<cr>")
    keymap.set("n", "<leader>ph", "<cmd>Telescope help_tags<cr>")
    keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
    keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
    keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
    keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")  -- list
  end,
}
