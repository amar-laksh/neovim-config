local neotest_status_ok, neotest = pcall(require, 'neotest')
if not neotest_status_ok then
    return
end

neotest.setup({
    adapters = {
        require("neotest-cpp") {
            args = { testFilesSuffix = "Test",
                buildPrefix = "_builds/build-debug" }
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
vim.api.nvim_set_hl(0, "NeotestFailed", { bold = true, bg = "red" })
vim.api.nvim_set_hl(0, "NeotestDir", { bold = true, fg = "#af3a03" })
vim.api.nvim_set_hl(0, "NeotestFile", { bold = true, fg = "#79740e" })
vim.api.nvim_set_hl(0, "NeotestTest", { bold = true, fg = "#ca9d4f" })
