return {
    {
        name = 'opencode-context',
        'raulbethencourt/opencode-context.nvim',
        lazy = false,
        opts = {
            tmux_target = nil,
            auto_detect_pane = true,
            auto_create_pane = true,
            split_direction = 'vertical',
            ui = {
                window_type = 'float',
                float = {
                    width = 0.8,
                    height = 4,
                    margin = 2,
                    border = 'rounded',
                    position = 'bottom',
                    title_pos = 'left',
                },
            },
        },
    },
}
