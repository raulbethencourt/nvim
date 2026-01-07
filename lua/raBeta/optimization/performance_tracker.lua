-- Performance Tracker Module for Neovim Optimization
-- Provides tools to measure startup time, memory usage, and performance metrics

local M = {}

-- Performance data storage
local performance_data = {
    startup_times = {},
    memory_usage = {},
    plugin_load_times = {},
    benchmarks = {},
}

-- Logger utility
local function log(level, message)
    vim.notify('[PerformanceTracker] ' .. message, level)
end

-- Measure startup time
-- Returns startup time in milliseconds
function M.measure_startup_time()
    local start_time = vim.loop.hrtime()
    -- Wait for Neovim to be fully loaded (next tick)
    vim.schedule(function()
        local end_time = vim.loop.hrtime()
        local startup_time_ms = (end_time - start_time) / 1000000 -- Convert to milliseconds
        table.insert(performance_data.startup_times, {
            timestamp = os.time(),
            duration_ms = startup_time_ms,
        })
        log(vim.log.levels.INFO, string.format('Startup time measured: %.2f ms', startup_time_ms))
    end)
end

-- Get startup time statistics
function M.get_startup_stats()
    local times = performance_data.startup_times
    if #times == 0 then
        return { count = 0, message = 'No startup measurements recorded yet' }
    end

    local total = 0
    local min_time = math.huge
    local max_time = 0

    for _, measurement in ipairs(times) do
        total = total + measurement.duration_ms
        min_time = math.min(min_time, measurement.duration_ms)
        max_time = math.max(max_time, measurement.duration_ms)
    end

    local avg_time = total / #times

    return {
        count = #times,
        average_ms = avg_time,
        min_ms = min_time,
        max_ms = max_time,
        latest_ms = times[#times].duration_ms,
    }
end

-- Measure memory usage
function M.measure_memory_usage()
    local mem_kb = vim.loop.resident_set_memory() / 1024 -- Convert to KB
    table.insert(performance_data.memory_usage, {
        timestamp = os.time(),
        memory_kb = mem_kb,
    })
    log(vim.log.levels.INFO, string.format('Memory usage measured: %.1f KB', mem_kb))
    return mem_kb
end

-- Get memory usage statistics
function M.get_memory_stats()
    local measurements = performance_data.memory_usage
    if #measurements == 0 then
        return { count = 0, message = 'No memory measurements recorded yet' }
    end

    local total = 0
    local min_mem = math.huge
    local max_mem = 0

    for _, measurement in ipairs(measurements) do
        total = total + measurement.memory_kb
        min_mem = math.min(min_mem, measurement.memory_kb)
        max_mem = math.max(max_mem, measurement.memory_kb)
    end

    local avg_mem = total / #measurements

    return {
        count = #measurements,
        average_kb = avg_mem,
        min_kb = min_mem,
        max_kb = max_mem,
        latest_kb = measurements[#measurements].memory_kb,
    }
end

-- Run performance benchmark
function M.run_benchmark(name, fn, iterations)
    iterations = iterations or 10
    local times = {}

    log(vim.log.levels.INFO, string.format('Running benchmark: %s (%d iterations)', name, iterations))

    for i = 1, iterations do
        local start = vim.loop.hrtime()
        fn()
        local duration = (vim.loop.hrtime() - start) / 1000000 -- ms
        table.insert(times, duration)
    end

    -- Calculate statistics
    local total = 0
    for _, time in ipairs(times) do
        total = total + time
    end

    local avg_time = total / #times
    local min_time = math.huge
    local max_time = 0
    for _, time in ipairs(times) do
        min_time = math.min(min_time, time)
        max_time = math.max(max_time, time)
    end

    local benchmark_result = {
        name = name,
        iterations = iterations,
        avg_time_ms = avg_time,
        min_time_ms = min_time,
        max_time_ms = max_time,
        timestamp = os.time(),
    }

    table.insert(performance_data.benchmarks, benchmark_result)

    log(vim.log.levels.INFO, string.format('Benchmark complete: %s - Avg: %.2f ms', name, avg_time))
    return benchmark_result
end

-- Get benchmark results
function M.get_benchmark_results()
    return vim.deepcopy(performance_data.benchmarks)
end

-- Create performance report
function M.generate_report()
    local report = {
        startup_stats = M.get_startup_stats(),
        memory_stats = M.get_memory_stats(),
        benchmark_results = M.get_benchmark_results(),
        plugin_count = #require('raBeta.optimization.plugin_manager').get_inventory(),
        generated_at = os.time(),
    }

    -- Save to file
    local data_dir = vim.fn.stdpath 'config' .. '/_bmad-output'
    vim.fn.mkdir(data_dir, 'p')
    local report_file = data_dir .. '/performance_report.json'
    local file = io.open(report_file, 'w')
    if file then
        file:write(vim.fn.json_encode(report))
        file:close()
        log(vim.log.levels.INFO, 'Performance report saved to ' .. report_file)
    end

    return report
end

-- Initialize performance tracking
function M.init()
    -- Measure initial memory usage
    M.measure_memory_usage()

    -- Set up autocmd to measure startup time on VimEnter
    vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
            M.measure_startup_time()
        end,
    })

    log(vim.log.levels.INFO, 'Performance tracker initialized')
end

return M