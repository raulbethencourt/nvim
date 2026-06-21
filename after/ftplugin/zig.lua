local options = {
    shiftwidth = 4,
    tabstop = 4,
}
for k, v in pairs(options) do
    vim.opt[k] = v
end

local keymap = require('raBeta.utils.utils').keymap
keymap('n', '<space>czb', ':compiler zig_build', '[C]ompiler [Z]ig build')
keymap('n', '<space>czt', ':compiler zig_test', '[C]ompiler [Z]ig test')
keymap('n', '<space>cze', ':compiler zig_build_exe', '[C]ompiler [Z]ig build exe')
keymap('n', '<space>cz', ':compiler zig', '[C]ompiler [Z]ig')
