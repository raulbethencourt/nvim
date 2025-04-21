-- NOTE: Basic Key Mappings vscode
local mappings = {
    [[imap <C-h> <C-w>h]],
    [[imap <C-j> <C-w>j]],
    [[imap <C-k> <C-w>k]],
    [[imap <C-l> <C-w>l]],

    -- whichkey mappings
    [[map <Space> <Leader>]],
    [[let mapleader="\<space>"]],

    -- Better indenting
    [[vnoremap < <gv]],
    [[vnoremap > >gv]],

    -- Simulate same TAB behavior in VSCode
    [[nmap <Tab> :Tabnext<CR>]],
    [[nmap <S-Tab> :Tabprev<CR>]],

    -- Fix ctrl+d and u not affecting selection in visual mode
    -- [[nnoremap <C-d> 27j]],
    -- [[vnoremap <C-d> 27j]],
    -- [[nnoremap <C-u> 27k]],
    -- [[vnoremap <C-u> 27k]],
    [[nnoremap <C-d> zz]],
    [[vnoremap <C-d> zz]],
    [[nnoremap <C-u> zz]],
    [[vnoremap <C-u> zz]],
}

---@diagnostic disable-next-line: unused-local
for i, v in ipairs(mappings) do
    vim.cmd(v)
end
