local keymap = require("raBeta.utils.utils").keymap
local icons = require("icons")
local telescope = require("telescope")
local action_layout = require("telescope.actions.layout")
local lga_actions = require("telescope-live-grep-args.actions")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
local builtin = require("telescope.builtin")
local live_grep_args_shortcuts = require('telescope-live-grep-args.shortcuts')

-- NOTE: Mappings to use inside telescope
local mappings = {
    ['<C-c>'] = actions.close,
    ['<C-u>'] = actions.preview_scrolling_up,
    ['<C-d>'] = actions.preview_scrolling_down,
    ['<C-p>'] = action_layout.toggle_preview,
}
local find_files_mappings = {
    ["<C-h>"] = function(prompt_bufnr)
        local opts = {}
        local action_state = actions_state
        local cmd = { "fd", "--type", "f", "--hidden", "--no-ignore" }
        local current_picker = action_state.get_current_picker(prompt_bufnr)

        opts.entry_maker = make_entry.gen_from_file(opts)
        current_picker:refresh(finders.new_oneshot_job(cmd, opts), {})
    end
}

telescope.setup {
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
        file_sorter = sorters.get_fuzzy_file,
        file_ignore_patterns = { 'node_modules', 'vendor', 'upgrades', 'upload', 'cache' },
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        path_display = { 'truncate' },
        preview = {
            filesize_limit = 0.1, -- MB
            treesitter = false,   -- treesitter freezes on big files
        },
        color_devicons = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        mappings = {
            n = mappings,
            i = mappings,
        },
    },
    pickers = {
        find_files = {
            mappings = {
                i = find_files_mappings,
                n = find_files_mappings
            }
        },
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
            mappings = {
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    ["<C-f>"] = actions.to_fuzzy_refine,
                },
            },
        },
        ['ui-select'] = {
            themes.get_dropdown {
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
telescope.load_extension 'fzf'
telescope.load_extension 'live_grep_args'
telescope.load_extension 'ui-select'

-- NOTE: Keymaps
keymap('n', '<leader><space>', builtin.buffers, 'Buffers')
keymap('n', '<leader>ss', builtin.spell_suggest, '[S]pell [S]uggest')
keymap('n', '<leader>sl', telescope.extensions.live_grep_args.live_grep_args, '[S]earch [L]ive Grep Args')
keymap('n', '<leader>so', builtin.command_history, '[S]earch command hist[O]ry')
keymap('n', '<leader>sf', builtin.find_files, '[S]earch [F]iles')
keymap('n', '<leader>sr', builtin.oldfiles, '[S]earch [R]ecently opened files')
keymap('n', '<leader>sh', builtin.help_tags, '[S]earch [H]elp')
keymap('n', '<leader>sR', builtin.registers, '[S]earch [Registers')
keymap('n', '<leader>sc', builtin.colorscheme, '[S]earch [C]olorscheme')
keymap('n', '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
keymap('n', '<leader>sb', builtin.current_buffer_fuzzy_find, '[S]earch in current [B]uffer')
keymap('n', '<leader>sw', live_grep_args_shortcuts.grep_word_under_cursor, '[S]earch [W]ord')
keymap('v', '<leader>sv', live_grep_args_shortcuts.grep_visual_selection,
    '[S]earch [V]isual selection')
keymap('n', '<leader>sm', function()
    builtin.man_pages { sections = { 'ALL' } }
end, '[S]earch [M]an pages')
keymap('n', '<leader>s.', function()
    builtin.find_files({ cwd = vim.fn.expand('%:p:h') })
end, '[S]earch File in path')
