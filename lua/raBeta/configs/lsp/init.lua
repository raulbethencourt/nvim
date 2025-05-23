require 'raBeta.configs.lsp.languages.php'
require 'raBeta.configs.lsp.languages.bash'
require 'raBeta.configs.lsp.languages.lua'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local mason_lspconfig = require 'mason-lspconfig'
-- Get intelephense licence
local get_intelephense_license = function()
    local f = assert(io.open(os.getenv 'HOME' .. '/intelephense/licence.txt', 'rb'))
    local content = f:read '*a'
    f:close()
    return string.gsub(content, '%s+', '')
end

-- NOTE: stop saving lsp logs, change to 'debug' to see them
vim.lsp.set_log_level 'off'
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        -- TODO: refactor this code
        local keymap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
        end

        keymap('<C-k>', function()
            require('lsp_signature').toggle_float_win()
        end, 'toggle signature')
        keymap('K', function()
            vim.lsp.buf.hover({
                border = "rounded",
            })
        end, 'toggle signature')
        -- keymap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        keymap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        -- keymap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]definition')
        keymap('gd', vim.lsp.buf.definition, '[G]oto [D]definition')
        keymap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        keymap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        keymap('gl', '<cmd>lua vim.diagnostic.open_float()<CR>', '[G]oto [L]ine diagnostics')
        keymap('<leader>ld', vim.lsp.buf.type_definition, '[L]sp Type [D]efinition')

        keymap('<leader>lf', function()
            vim.lsp.buf.format { async = true }
        end, '[L]sp [F]ormat')
        vim.keymap.set('v', '<leader>lf', require("raBeta.utils.utils").visual_format,
            { buffer = args.buf, desc = "Visual [F]ormat" })

        keymap('<leader>lD', '<cmd>Telescope diagnostics<CR>', '[L]sp Telescope Workspace [D]iagnostics')

        keymap('<leader>lb', function()
            require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown {
                winblend = 0,
                previewer = true,
                layout_strategy = 'vertical_no_titles',
                layout_config = {
                    height = 0.5,
                    prompt_position = 'top',
                    width = 0.4,
                    preview_height = 0.6,
                },
                bufnr = 0,
                no_sign = true,
            })
        end, '[L]sp Telescope [B]uffer Diagnostics')

        keymap('<leader>ls', function()
            require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_dropdown {
                winblend = 0,
                previewer = true,
                layout_strategy = 'vertical_no_titles',
                layout_config = {
                    height = 0.5,
                    prompt_position = 'top',
                    width = 0.4,
                    preview_height = 0.6,
                },
                bufnr = 0,
                no_sign = true,
            })
        end, '[L]sp Document [S]ymbols')

        keymap('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]sp [W]orkspace symbols')
        keymap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
        keymap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
        keymap('<leader>ln', vim.lsp.buf.add_workspace_folder, '[L]sp [W]orkspace [A]dd Folder')
        keymap('<leader>lx', vim.lsp.buf.remove_workspace_folder, '[L]sp [W]orkspace [R]emove Folder')
        keymap('<leader>lI', '<cmd>Mason<cr>', '[L]sp [I]nstall with mason')
        keymap('<leader>li', '<cmd>LspInfo<cr>', '[L]sp [I]nfo')
        keymap('<leader>ll', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[L]sp [W]orkspace [L]ist Folders')
    end
})

-- Servers configuration
local servers = {
    emmet_ls = {
        filetypes = { 'twig', 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
        init_options = {
            html = {
                options = {
                    ['bem.enabled'] = true,
                },
            },
        },
    },
    jqls = {
        filetypes = { 'json', 'jsonc' },
    },
    bashls = {
        filetypes = { 'sh', 'zsh', 'bash' },
    },
    clangd = {},
    taplo = {},
    marksman = {},
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    cssls = {},
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        '${3rd}/luv/library',
                        unpack(vim.api.nvim_get_runtime_file('', true)),
                    },
                },
                telemetry = { enable = false },
                format = { enable = false },
            },
        },
    },
    htmx = { filetypes = { 'html', 'twig', 'php' } },
    intelephense = {
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        init_options = {
            licenceKey = get_intelephense_license(),
            storagePath = '/home/rabeta/.intelephense',
            files = {
                maxSize = 5000000,
            },
            phpMemoryLimit = '4096M',
        },
        diagnostics = {
            enable = true,
        },
        format = {
            enable = false,
        },
        flags = {
            debounce_text_changes = 150,
        },
    },
    zls = {
        format = {
            enable = true,
        },
        diagnostics = {
            enable = true,
        },
    },
    sqls = {},
    ts_ls = {},
}
for server, config in pairs(servers) do
    vim.lsp.enable(server)
    vim.lsp.config[server] = config
end
vim.filetype.add {
    extension = {
        zsh = 'zsh',
    },
}
vim.lsp.config('*', {
    capabilities = capabilities
})

-- Diagnostic configuration
local icons = require 'icons'
vim.diagnostic.config {
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
    -- disblae inline hints
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error .. ' ',
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning .. ' ',
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint .. ' ',
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Information .. ' ',
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.HINT] = 'HintMsg',
            [vim.diagnostic.severity.INFO] = 'InfoMsg',
        },
    },
}
