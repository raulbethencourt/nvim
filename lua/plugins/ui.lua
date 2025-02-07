local icons = require("icons")
local keymap = require("config.utils").keymap

return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = true
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_cursor = "green"
      vim.g.gruvbox_material_ui_contrast = "low"
      vim.g.gruvbox_material_float_style = "dim"
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    config = function()
      require("obsidian").get_client().opts.ui.enable = false
      vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()["ObsidianUI"], 0, -1)
      require("render-markdown").setup({
        enabled = false,
      })
      keymap("n", "<leader>um", "<cmd>RenderMarkdown toggle<CR>", "toggle render [M]arkdown")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      { "MunifTanjim/nui.nvim", lazy = true },
    },
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
          format = {
            cmdline = { pattern = "^:", icon = icons.ChevronShortRight, lang = "vim", title = "" },
          },
        },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false,
          },
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = "rounded", -- add a border to hover docs and signature help
        },
        views = {
          cmdline_popup = {
            border = {
              style = "rounded",
              padding = { 1, 1 },
            },
            filter_options = {},
            win_options = {
              winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
            },
            position = {
              row = 7,
              col = "50%",
            },
            size = {
              width = 100,
              height = "auto",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 15,
              col = "50%",
            },
            size = {
              width = 100,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 1, 2 },
            },
            win_options = {
              winhl = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
            },
          },
        },
      })
    end,
  },
}
