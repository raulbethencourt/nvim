--[[=================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||      INIT.LUA      ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||                    ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=================================================================--]]

-- NOTE: install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: need to set leader and termguicolors before lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.termguicolors = true

-- NOTE: vscode nvim settings
if vim.g.vscode then
    require 'vscode.mappings_vscode'

    local cmd = {
        [[source $HOME/.config/nvim/vscode/vim_settings.vim]],
        [[source $HOME/.config/nvim/vscode/functions.vim]],
        [[source $HOME/.config/nvim/vscode/settings.vim]],
        [[nnoremap z= <Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>]],
    }
    ---@diagnostic disable-next-line: unused-local
    for i, v in ipairs(cmd) do
        vim.cmd(v)
    end
end

local env_name = vim.g.vscode and 'vscode' or 'raBeta'

require('lazy').setup({
    spec = {
        import = env_name .. '.plugins'
    },
    checker = { enabled = true },
}, {})

require(env_name .. '.configs')
