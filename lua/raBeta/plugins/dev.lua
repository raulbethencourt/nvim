return {
    {
        dir = '~/plugins/present.nvim',
        lazy = true,
        config = function()
            require 'present'
        end,
    },
    {
        name = 'opencode-context',
        dir = '~/plugins/opencode-context.nvim',
        lazy = false,
        opts = {
            tmux_target = nil,
            auto_detect_pane = true,
            auto_create_pane = true,
            split_direction = 'vertical',
            ui = {
                window_type = 'float',
                float = {
                    width = 0.6,
                    height = 3,
                    margin = 8,
                    border = 'rounded',
                    position = 'bottom',
                    title_pos = 'left',
                },
            },
        },
        keys = {
            { '<leader>ac', '<cmd>OpencodeSend<cr>', mode = { 'v', 'n' }, desc = 'Send prompt to opencode' },
            { '<leader>at', '<cmd>OpencodeSwitchMode<cr>', desc = 'Toggle opencode mode' },
            { '<leader>as', '<cmd>OpencodeSessions<cr>', desc = 'Opencode in specific session' },
            { '<leader>ap', '<cmd>OpencodePrompt<cr>', mode = { 'v', 'n' }, desc = 'Open opencode persistent prompt' },
        },
        cmd = { 'OpencodeSend', 'OpencodeSwitchMode' },
    },
}
