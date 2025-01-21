local icons = require 'icons'
local keymap = require("raBeta.utils.utils").keymap
local action_layout = require 'telescope.actions.layout'

-- NOTE: Mappings to use inside telescope
local mappings = {
    ['<C-c>'] = require('telescope.actions').close,
    ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
    ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
    ['<C-p>'] = action_layout.toggle_preview,
}

require('telescope').setup {
    defaults = {
        layout_config = {
            bottom_pane = {
                preview_width = 0.55,
                height = 0.7,
                preview_cutoff = 120,
                prompt_position = "top"
            },
            center = {
                preview_width = 0.55,
                height = 0.4,
                preview_cutoff = 40,
                prompt_position = "top",
                width = 0.5
            },
            cursor = {
                preview_width = 0.55,
                height = 0.9,
                preview_cutoff = 40,
                width = 0.8
            },
            horizontal = {
                preview_width = 0.55,
                height = 0.9,
                preview_cutoff = 120,
                prompt_position = "bottom",
                width = 0.9
            },
            vertical = {
                preview_width = 0.55,
                height = 0.9,
                preview_cutoff = 40,
                prompt_position = "bottom",
                width = 0.8
            }
        },
        vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim',
        },
        prompt_prefix = '  ' .. icons.ui.Target .. '  ',
        prompt_title = false,
        selection_caret = '  ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        layout_strategy = 'horizontal_no_titles',
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        file_ignore_patterns = { 'node_modules', 'vendor', 'upgrades', 'upload', 'cache' },
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        path_display = { 'truncate' },
        preview = {
            filesize_limit = 0.1, -- MB
            treesitter = false,   -- treesitter freezes on big files
        },
        color_devicons = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
        mappings = {
            n = mappings,
            i = mappings,
        },
    },
    pickers = {
        buffers = {
            theme = "dropdown",
            sort_lastused = true,
            sort_mru = true,
            show_all_buffers = true,
            previewer = false,
            initial_mode = 'insert',
            layout_strategy = 'vertical_no_titles',
            prompt_title = false,
            layout_config = {
                height = 0.2,
                prompt_position = 'bottom',
                width = 0.3,
            }
        },
        current_buffer_fuzzy_find = {
            theme = "dropdown",
            winblend = 0,
            previewer = true,
            layout_strategy = 'vertical_no_titles',
            layout_config = {
                height = 0.6,
                prompt_position = 'top',
                width = 0.4,
                preview_height = 0.5,
            },
        },
        colorscheme = {
            layout_strategy = 'vertical_no_titles',
            layout_config = {
                height = 0.6,
            },
        },
        man_pages = {
            theme = "ivy",
            layout_config = {
                height = 0.6,
            },
        },
        registers = {
            theme = "ivy",
            layout_config = {
                height = 0.6,
            },
        },
        help_tags = {
            theme = "ivy",
            layout_config = {
                height = 0.6,
            },
        },
        command_history = {
            theme = "ivy",
            layout_config = {
                height = 0.6,
            },
        },
        keymaps = {
            theme = "ivy",
            layout_config = {
                height = 0.6,
            },
        },
    },
    extensions = {
        live_grep_args = {
            auto_quoting = true,
            layout_strategy = 'horizontal_no_titles',
        },
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
                winblend = 0,
                previewer = false,
                layout_strategy = 'vertical_no_titles'
            },
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
        },
    },
}

-- NOTE: Enable telescope extensions
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'live_grep_args'
require('telescope').load_extension 'ui-select'
require('telescope').load_extension 'menufacture'

-- NOTE: Keymaps
keymap('n', '<leader><space>', require('telescope.builtin').buffers, 'Buffers')
keymap('n', '<C-s>', require('telescope.builtin').spell_suggest, '[S]pell [S]uggest')
keymap('n', '<leader>so', "<cmd>Telescope command_history<cr>", '[S]earch command hist[O]ry')
keymap('n', '<leader>sl', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    '[S]earch [L]ive Grep Args')
keymap('n', '<leader>so', "<cmd>Telescope command_history<cr>", '[S]earch command hist[O]ry')
keymap('n', '<leader>sf', require('telescope').extensions.menufacture.find_files, '[S]earch [F]iles')
keymap('n', '<leader>sr', require('telescope').extensions.menufacture.oldfiles,
    '[S]earch [R]ecently opened files')
keymap('n', '<leader>sg', require('telescope').extensions.menufacture.live_grep, '[S]earch live [G]rep')
keymap('n', '<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
keymap('n', '<leader>sR', require('telescope.builtin').registers, '[S]earch [Registers')
keymap('n', '<leader>sw', require('telescope').extensions.menufacture.grep_string, '[S]earch [W]ord')
keymap('v', '<leader>sv', require('telescope-live-grep-args.shortcuts').grep_visual_selection,
    '[S]earch [V]isual selection')
keymap('n', '<leader>sc', require('telescope.builtin').colorscheme, '[S]earch [C]olorscheme')
keymap('n', '<leader>sk', require('telescope.builtin').keymaps, '[S]earch [K]eymaps')
keymap('n', '<leader>sm', function()
    require('telescope.builtin').man_pages { sections = { 'ALL' } }
end, '[S]earch [M]an pages')
keymap('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find, '[S]earch in current [B]uffer')
keymap('n', '<leader>st', '<cmd>todotelescope<cr>', '[s]search [t]odo')
