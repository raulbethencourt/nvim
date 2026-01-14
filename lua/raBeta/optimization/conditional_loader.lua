-- Conditional Loader for Neovim Optimization
-- Provides intelligent plugin loading based on context and filetypes

local M = {}

local plugin_manager = require 'raBeta.optimization.plugin_manager'
local performance_tracker = require 'raBeta.optimization.performance_tracker'

-- Logger utility
local function log(level, message)
    vim.notify('[ConditionalLoader] ' .. message, level)
end

-- Configuration for conditional loading
local config = {
    -- Filetype-based loading rules
    filetype_loaders = {
        python = { 'python', 'dap' },
        javascript = { 'javascript', 'typescript', 'node' },
        typescript = { 'typescript', 'javascript', 'node' },
        lua = { 'lua', 'neovim' },
        rust = { 'rust', 'cargo' },
        go = { 'go', 'golang' },
        markdown = { 'markdown', 'writing' },
        json = { 'json', 'formatting' },
        yaml = { 'yaml', 'kubernetes' },
        dockerfile = { 'docker' },
        terraform = { 'terraform', 'hcl' },
    },

    -- Context-based loading rules
    context_loaders = {
        git_commit = { 'git' },
        git_blame = { 'git' },
        debug_session = { 'dap', 'debug' },
        terminal_mode = { 'terminal' },
        file_explorer = { 'explorer' },
    },

    -- Performance thresholds
    max_plugins_per_session = 30,
    lazy_load_delay = 100, -- ms
}

-- Track loaded plugins for this session
local session_loaded_plugins = {}
local lazy_load_queue = {}

-- Initialize conditional loading
function M.init()
    -- Set up filetype-based autocommands
    M.setup_filetype_loading()

    -- Set up context-based loading
    M.setup_context_loading()

    -- Monitor plugin loading performance
    M.setup_performance_monitoring()

    log(vim.log.levels.INFO, 'Conditional loader initialized')
end

-- Setup filetype-based conditional loading
function M.setup_filetype_loading()
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local ft = args.match
            M.load_for_filetype(ft)
        end,
    })

    log(vim.log.levels.INFO, 'Filetype-based loading configured')
end

-- Setup context-based conditional loading
function M.setup_context_loading()
    -- Git commands
    vim.api.nvim_create_autocmd('CmdlineEnter', {
        pattern = 'Git*',
        callback = function()
            M.load_for_context 'git_commit'
        end,
    })

    -- Debug commands
    vim.api.nvim_create_autocmd('CmdlineEnter', {
        pattern = 'Dap*',
        callback = function()
            M.load_for_context 'debug_session'
        end,
    })

    -- Terminal
    vim.api.nvim_create_autocmd('TermOpen', {
        callback = function()
            M.load_for_context 'terminal_mode'
        end,
    })

    log(vim.log.levels.INFO, 'Context-based loading configured')
end

-- Setup performance monitoring for lazy loading
function M.setup_performance_monitoring()
    -- Monitor plugin load performance
    vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyLoad',
        callback = function(args)
            local plugin_name = args.data or args.match
            if plugin_name then
                performance_tracker.run_benchmark(
                    'plugin_load_' .. plugin_name,
                    function() end, -- Placeholder for actual load time measurement
                    1
                )
                log(vim.log.levels.DEBUG, string.format('Plugin loaded: %s', plugin_name))
            end
        end,
    })
end

-- Load plugins for specific filetype
function M.load_for_filetype(filetype)
    if not filetype or not config.filetype_loaders[filetype] then
        return
    end

    local plugins_to_load = config.filetype_loaders[filetype]

    for _, plugin_category in ipairs(plugins_to_load) do
        M.lazy_load_category(plugin_category)
    end

    log(vim.log.levels.INFO, string.format('Triggered filetype loading for: %s', filetype))
end

-- Load plugins for specific context
function M.load_for_context(context)
    if not context or not config.context_loaders[context] then
        return
    end

    local plugins_to_load = config.context_loaders[context]

    for _, plugin_category in ipairs(plugins_to_load) do
        M.lazy_load_category(plugin_category)
    end

    log(vim.log.levels.INFO, string.format('Triggered context loading for: %s', context))
end

-- Lazy load plugins by category
function M.lazy_load_category(category)
    -- Check if we're at the plugin limit
    if vim.tbl_count(session_loaded_plugins) >= config.max_plugins_per_session then
        log(vim.log.levels.WARN, string.format('Plugin limit reached (%d), skipping category: %s', config.max_plugins_per_session, category))
        return
    end

    -- Find plugins in this category
    local inventory = plugin_manager.get_inventory()
    local plugins_to_load = {}

    for _, plugin in ipairs(inventory) do
        local name_lower = plugin.name:lower()
        if name_lower:find(category) and not plugin.loaded and not session_loaded_plugins[plugin.name] then
            table.insert(plugins_to_load, plugin)
        end
    end

    if #plugins_to_load == 0 then
        log(vim.log.levels.DEBUG, string.format('No plugins found for category: %s', category))
        return
    end

    -- Queue for lazy loading
    for _, plugin in ipairs(plugins_to_load) do
        table.insert(lazy_load_queue, plugin.name)
        session_loaded_plugins[plugin.name] = true
    end

    -- Trigger lazy loading after delay
    vim.defer_fn(function()
        M.process_lazy_load_queue()
    end, config.lazy_load_delay)

    log(vim.log.levels.INFO, string.format('Queued %d plugins for lazy loading in category: %s', #plugins_to_load, category))
end

-- Process the lazy load queue
function M.process_lazy_load_queue()
    if #lazy_load_queue == 0 then
        return
    end

    -- Load plugins (this would integrate with Lazy's lazy loading)
    -- For now, we'll mark them as "would be loaded"
    for _, plugin_name in ipairs(lazy_load_queue) do
        log(vim.log.levels.INFO, string.format('Would lazy load plugin: %s', plugin_name))
        -- In a real implementation, this would trigger Lazy's lazy loading
    end

    lazy_load_queue = {}
end

-- Get conditional loading statistics
function M.get_statistics()
    return {
        session_loaded_count = vim.tbl_count(session_loaded_plugins),
        lazy_load_queue_size = #lazy_load_queue,
        max_plugins_allowed = config.max_plugins_per_session,
        configured_filetypes = vim.tbl_count(config.filetype_loaders),
        configured_contexts = vim.tbl_count(config.context_loaders),
    }
end

-- Configure conditional loading rules
function M.configure_rules(new_config)
    config = vim.tbl_deep_extend('force', config, new_config or {})
    log(vim.log.levels.INFO, 'Conditional loading rules updated')
end

-- Reset session state (for testing)
function M.reset_session()
    session_loaded_plugins = {}
    lazy_load_queue = {}
    log(vim.log.levels.INFO, 'Session state reset')
end

return M