local keymap = require("config.utils").keymap

return {
  {
    "mbbill/undotree",
    config = function()
      keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", "Toggle [U]ndoTree")
    end,
  },
  {
    "max397574/better-escape.nvim",
    config = true,
  },
  {
    "aserowy/tmux.nvim",
    config = true,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
        sign = {
          enabled = true,
          text = require("icons").diagnostics.BoldHint,
          hl = "LightBulbSign",
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        skip_confirm_for_simple_edits = true,
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-d>"] = "actions.preview_scroll_down",
          ["<C-u>"] = "actions.preview_scroll_up",
          ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
          ["<esc>"] = "actions.close",
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 5,
          max_width = 0,
          max_height = 0,
          win_options = {
            winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
          },
        },
        preview_win = {
          win_options = {
            winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
          },
        },
        progress = {
          win_options = {
            winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
          },
        },
      })
      keymap("n", "<leader>e", require("oil").toggle_float, "[O]il [T]oggle float")
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "personal",
            path = "~/vaults",
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        attachments = {
          img_folder = "assets",
        },
        ---@diagnostic disable-next-line: missing-fields
        daily_notes = {
          folder = "daily",
          template = "daily_template",
        },
        ---@diagnostic disable-next-line: missing-fields
        templates = {
          folder = "templates",
          -- A map for custom variables, the key should be the variable and the value a function
          substitutions = {},
        },
        ---@diagnostic disable-next-line: missing-fields
        mappings = {
          ["<space>os"] = {
            action = function()
              return require("obsidian").util.smart_action()
            end,
            opts = { buffer = true, expr = true, desc = "[O]bsidian [S]mart action" },
          },
        },
      })
      keymap("n", "<leader>oh", "<cmd>ObsidianToggleCheckbox<CR>", "[O]bsidian toggle c[H]eckbox")
      keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", "[O]bsidian [B]ack links")
      keymap("n", "<leader>ot", "<cmd>ObsidianTags<CR>", "[O]bsidian [T]ags")
      keymap("n", "<leader>od", "<cmd>ObsidianToday<CR>", "[O]bsidian to[D]ay")
      keymap("n", "<leader>oi", "<cmd>ObsidianPasteImg<CR>", "[O]bsidian paste [I]mage")
      keymap("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", "[O]bsidian [W]orkspace")
      keymap("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", "[O]bsidian [O]pen")
      keymap("n", "<leader>oe", "<cmd>ObsidianTemplate<CR>", "[O]bsidian t[E]mplate")
    end,
  },
}
