local neotest_status_ok, neotest = pcall(require, 'neotest')
if not neotest_status_ok then
    return
end
local function lines_from(file)
    local function file_exists(filename)
        local f = io.open(filename, "rb")
        if f then f:close() end
        return f ~= nil
    end

    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

local function read_lines(filename)
    local file = vim.fn.getcwd() .. filename
    local lines = lines_from(file)
    for k, v in pairs(lines) do
        if k then
            return v
        end
        return ""
    end
end

neotest.setup({
    adapters = {
        require("neotest-cpp") {
            args = {
                testSuffixes = { "Test", "test", "Tests", "tests" },
                buildPrefix = "_builds/build-debug",
                buildFn = function(target, root)
                    -- Using a custom build script for our test target
                    local lines = read_lines("/.dapTarget")
                    return string.format(lines, target)
                end
            }
        },
    },
    icons = {
        passed = "✓",
        running = "〇",
        failed = "✗",
    },
    summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t"
        },
        open = "botright vsplit | vertical resize 50"
    }

})
vim.api.nvim_set_hl(0, "NeotestPassed", { bold = true, blend = 0, fg = "green" })
vim.api.nvim_set_hl(0, "NeotestFailed", { bold = true, blend = 0, bg = "red" })
vim.api.nvim_set_hl(0, "NeotestRunning", { bold = true, blend = 0, bg = "orange" })
vim.api.nvim_set_hl(0, "NeotestDir", { bold = true, fg = "#af3a03" })
vim.api.nvim_set_hl(0, "NeotestFile", { bold = true, fg = "#79740e" })
vim.api.nvim_set_hl(0, "NeotestTest", { bold = true, fg = "#ca9d4f" })
