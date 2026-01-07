-- Rationale Documentation Integrator for Neovim Optimization
-- Manages rationales for plugin inclusion/exclusion

local M = {}

local plugin_manager = require('raBeta.optimization.plugin_manager')

-- Logger utility
local function log(level, message)
    vim.notify('[DocumentationIntegrator] ' .. message, level)
end

-- In-memory storage for rationales (keyed by plugin name)
local rationales = {}

-- Data storage path
local data_dir = vim.fn.stdpath('config') .. '/_bmad-output'
local rationales_file = data_dir .. '/plugin_rationales.json'

-- Load rationales from file
local function load_rationales()
    local file = io.open(rationales_file, 'r')
    if file then
        local content = file:read('*all')
        file:close()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and data then
            rationales = data
            log(vim.log.levels.INFO, 'Loaded rationales from file')
        else
            log(vim.log.levels.WARN, 'Failed to decode rationales file')
        end
    end
end

-- Save rationales to file
local function save_rationales()
    vim.fn.mkdir(data_dir, 'p')
    local file = io.open(rationales_file, 'w')
    if file then
        local content = vim.fn.json_encode(rationales)
        file:write(content)
        file:close()
        log(vim.log.levels.INFO, 'Saved rationales to file')
    else
        log(vim.log.levels.ERROR, 'Failed to save rationales to file')
    end
end

-- Initialize: load existing rationales
function M.init()
    load_rationales()
end

-- Add or update rationale for a plugin
function M.add_rationale(plugin_name, rationale_text, category)
    rationales[plugin_name] = {
        text = rationale_text,
        category = category or 'general',
        timestamp = os.time(),
    }
    save_rationales()
    log(vim.log.levels.INFO, string.format('Added rationale for %s', plugin_name))
end

-- Get rationale for a plugin
function M.get_rationale(plugin_name)
    return rationales[plugin_name]
end

-- List all rationales
function M.list_rationales()
    return vim.deepcopy(rationales)
end

-- Generate documentation for plugins
function M.generate_documentation()
    local inventory = plugin_manager.get_inventory()
    local docs = {}

    for _, plugin in ipairs(inventory) do
        local rationale = M.get_rationale(plugin.name)
        docs[plugin.name] = {
            metadata = plugin,
            rationale = rationale,
        }
    end

    -- Save to file
    local doc_file = data_dir .. '/plugin_documentation.json'
    local file = io.open(doc_file, 'w')
    if file then
        file:write(vim.fn.json_encode(docs))
        file:close()
        log(vim.log.levels.INFO, 'Generated plugin documentation')
    end

    return docs
end

-- Suggest rationales for uncategorized plugins
function M.suggest_rationales()
    local inventory = plugin_manager.get_inventory()
    local suggestions = {}

    for _, plugin in ipairs(inventory) do
        if not M.get_rationale(plugin.name) then
            -- Suggest based on category or usage
            local suggestion = 'Plugin ' .. plugin.name .. ' - '
            if plugin.loaded then
                suggestion = suggestion .. 'Currently loaded. '
            end
            if #plugin.dependencies > 0 then
                suggestion = suggestion .. 'Has ' .. #plugin.dependencies .. ' dependencies. '
            end
            suggestion = suggestion .. 'Review for necessity.'
            suggestions[plugin.name] = suggestion
        end
    end

    return suggestions
end

return M