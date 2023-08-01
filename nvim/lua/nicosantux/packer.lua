-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
  -- packer can manage itself
  use "wbthomason/packer.nvim"

  use "nvim-lua/plenary.nvim"

  use "lewis6991/gitsigns.nvim"

  use {"akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons"}

  use "stevearc/dressing.nvim"

  use "MunifTanjim/nui.nvim"

  use "folke/noice.nvim"

  -- NeoVim theme
  use "rebelot/kanagawa.nvim"

  -- tmux & split window navigation
  use "christoomey/vim-tmux-navigator"

  -- Files explorer
  use ({"nvim-telescope/telescope-fzf-native.nvim", run = "make"})
  use { "nvim-telescope/telescope.nvim", tag = "0.1.1" }
  use("nvim-treesitter/nvim-treesitter", {run  = ":TSUpdate"})
  use "ryanoasis/vim-devicons"
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly" -- optional, updated every week. (see issue #1193)
  }

  -- Status line
  use "nvim-lualine/lualine.nvim"

  -- Comments
  use {
    "numToStr/Comment.nvim",
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

  -- Auto closing
  use "windwp/nvim-autopairs"
  use "windwp/nvim-ts-autotag"

  -- Autocompletion
  use "hrsh7th/nvim-cmp" -- completion plugin
  use "hrsh7th/cmp-buffer" -- source for text in buffer
  use "hrsh7th/cmp-path" -- source for file system paths

  -- Snippets
  use "L3MON4D3/LuaSnip" -- snippet engine
  use "saadparwaiz1/cmp_luasnip" -- for autocompletion
  use "rafamadriz/friendly-snippets" -- useful snippets

  -- Managing & installing lsp servers, linters & formatters
  use "williamboman/mason.nvim" -- in charge of managing lsp servers, linters & formatters
  use "williamboman/mason-lspconfig.nvim" -- bridges gap b/w mason & lspconfig

  -- Configuring lsp servers
  use "neovim/nvim-lspconfig" -- easily configure language servers
  use "hrsh7th/cmp-nvim-lsp" -- for autocompletion
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    requires = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  }) -- enhanced lsp uis
  use "jose-elias-alvarez/typescript.nvim" -- additional functionality for typescript server (e.g. rename file & update imports)
  use "onsails/lspkind.nvim" -- vs-code like icons for autocompletion

  -- Formatting & linting
  use "jose-elias-alvarez/null-ls.nvim" -- configure formatters & linters
  use "jayp0521/mason-null-ls.nvim" -- bridges gap b/w mason & null-ls
  use "MunifTanjim/eslint.nvim"
  use "editorconfig/editorconfig-vim"
end)
