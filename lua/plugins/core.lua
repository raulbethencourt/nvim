local icons = require("icons")

return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { map = LazyVim.safe_keymap_set },
      words = { enabled = true },
    },
  },
  { "MagicDuck/grug-far.nvim", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = false,
        severity_sort = false,
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        }
      }
    }
  }
}
