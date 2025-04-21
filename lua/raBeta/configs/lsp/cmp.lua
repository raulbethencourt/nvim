local luasnip = require 'luasnip'
local lspkind = require('lspkind')
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/nvim/snippets' } }
luasnip.config.setup {}

vim.keymap.set({ 'i', 's' }, '<c-k>', function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<c-j>', function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<c-l>', function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end, { silent = true })

local cmp = require 'cmp'

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})
cmp.setup {
    window = {
        completion = {
            border = 'rounded',
            winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
            side_padding = 1,
        },
        documentation = {
            border = 'rounded',
            winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal",
            side_padding = 1,
        },
    },
    ---@diagnostic disable-next-line: missing-fields
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',     -- show only symbol annotations
            maxwidth = {
                menu = 50,            -- leading text (labelDetails)
                abbr = 50,            -- actual suggestion item
            },
            ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            symbol_map = { Copilot = "" },
            before = function(entry, vim_item)
                return vim_item
            end
        })
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        {
            name = 'copilot',
            group_index = 2
        },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "lazydev" },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'render-markdown' },
        {
            name = 'nvim_lua',
            keyword_length = 2,
        },
        {
            name = 'vsnip',
            keyword_length = 2,
        }
    }
}
