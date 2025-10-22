return {
    {
        dir = '~/plugins/present.nvim',
        lazy = true,
        config = function()
            require 'present'
        end,
    },
    {
        dir = '~/plugins/opencode-context.nvim',
        lazy = false,
        opts = {
            tmux_target = nil,
            auto_detect_pane = true,
            ui = {
                window_type = 'float',
                float = {
                    width = 0.5,
                    height = 6,
                    border = 'rounded',
                    position = 'top',
                    margin = 6,
                },
            },
        },
        keys = {
            { '<leader>ac', '<cmd>OpencodeSend<cr>', mode = { 'v', 'n' }, desc = 'Send prompt to opencode' },
            { '<leader>at', '<cmd>OpencodeSwitchMode<cr>', desc = 'Toggle opencode mode' },
            { '<leader>ap', '<cmd>OpencodePrompt<cr>', desc = 'Open opencode persistent prompt' },
        },
        cmd = { 'OpencodeSend', 'OpencodeSwitchMode' },
    },
}
